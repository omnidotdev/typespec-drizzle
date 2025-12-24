import type {
  EmitContext,
  Enum,
  Model,
  ModelProperty,
  Scalar,
  Type,
} from "@typespec/compiler";
import { navigateProgram } from "@typespec/compiler";

import { Output, SourceDirectory, SourceFile } from "@alloy-js/core";

import { writeOutput } from "@typespec/emitter-framework";

import {
  getColumnName,
  getCompositeId,
  getDefaultValue,
  getIndexOptions,
  getRelationOptions,
  getSqlExpression,
  getTableName,
  getTableOptions,
  getUniqueOptions,
  getUuidOptions,
  isAutoIncrement,
  isIndexed,
  isJunction,
  isManyToMany,
  isManyToOne,
  isOneToMany,
  isOneToOne,
  isPrimaryKey,
  isTable,
  isUnique,
  isUuid,
} from "./lib.js";

import type {
  ForeignKeyAction,
  ManyToManyOptions,
  RelationOptions,
} from "./lib.js";

// import tracker

/**
 * Track imports needed for the generated Drizzle schema.
 */
class ImportTracker {
  private pgCoreImports = new Set<string>();
  private ormImports = new Set<string>();

  addPgCore = (type: string): this => {
    this.pgCoreImports.add(type);

    return this;
  };

  addOrm = (type: string): this => {
    this.ormImports.add(type);

    return this;
  };

  needsSql = (): this => this.addOrm("sql");

  needsRelations = (): this => this.addOrm("relations");

  generate = (): string => {
    const pgCore = Array.from(this.pgCoreImports).sort().join(", ");
    const orm = Array.from(this.ormImports).sort().join(", ");

    let result = `import { ${pgCore} } from 'drizzle-orm/pg-core';`;

    if (orm) result += `\nimport { ${orm} } from 'drizzle-orm';`;

    return result;
  };
}

// type mapping

/**
 * TypeSpec scalar to Drizzle PostgreSQL type mapping.
 */
const scalarToDrizzle = new Map<string, string>([
  // strings
  ["string", "text"],

  // integers
  ["int8", "smallint"],
  ["int16", "smallint"],
  ["int32", "integer"],
  ["int64", "bigint"],
  ["uint8", "smallint"],
  ["uint16", "integer"],
  ["uint32", "bigint"],
  ["safeint", "integer"],

  // floats
  ["float32", "real"],
  ["float64", "doublePrecision"],
  ["numeric", "numeric"],
  ["decimal", "numeric"],
  ["decimal128", "numeric"],

  // boolean
  ["boolean", "boolean"],

  // date/time
  ["plainDate", "date"],
  ["plainTime", "time"],
  ["utcDateTime", "timestamp"],
  ["offsetDateTime", "timestamp"],
  ["duration", "interval"],

  // binary
  ["bytes", "bytea"],

  // json/unknown
  ["unknown", "jsonb"],
  ["object", "jsonb"],
]);

/**
 * Map a TypeSpec type to a Drizzle column type.
 */
const mapTypeToDrizzle = (type: Type, imports: ImportTracker): string => {
  if (type.kind === "Scalar") {
    const scalar = type as Scalar;
    const drizzleType = scalarToDrizzle.get(scalar.name) ?? "text";

    imports.addPgCore(drizzleType);

    return drizzleType;
  }

  if (type.kind === "Enum") return "enum";

  imports.addPgCore("text");

  return "text";
};

// relationship types

/**
 * Relationship information for generating Drizzle relations.
 */
interface Relationship {
  type: "one-to-one" | "one-to-many" | "many-to-many";
  fromModel: Model;
  toModel: Model;
  fromField?: string;
  toField?: string;
  junctionTable?: Model;
  relationName?: string;
  onDelete?: ForeignKeyAction;
  onUpdate?: ForeignKeyAction;
}

// model utilities

/**
 * Check if a model is a built-in TypeSpec model.
 */
const isBuiltInTypeSpecModel = (model: Model): boolean => {
  const builtInModels = [
    "Array",
    "Record",
    "ServiceOptions",
    "DiscriminatedOptions",
    "ExampleOptions",
    "OperationExample",
    "VisibilityFilter",
    "EnumMember",
    "Model",
    "Scalar",
    "Enum",
    "Union",
    "ModelProperty",
    "Operation",
    "Namespace",
    "Interface",
    "UnionVariant",
    "StringTemplate",
  ];

  return (
    builtInModels.includes(model.name) ||
    model.namespace?.name === "TypeSpec" ||
    model.namespace?.name === "Reflection" ||
    model.namespace?.name === "Drizzle" ||
    model.sourceModel?.namespace?.name === "TypeSpec"
  );
};

/**
 * Get all models from the TypeSpec program.
 */
const getAllModels = (context: EmitContext): Model[] => {
  const models: Model[] = [];

  navigateProgram(context.program, {
    model(model) {
      if (
        !model.name.startsWith("_") &&
        !isBuiltInTypeSpecModel(model) &&
        !model.namespace?.name?.startsWith("TypeSpec") &&
        isTable(context.program, model)
      )
        models.push(model);
    },
  });

  return models;
};

/**
 * Get all enums from the TypeSpec program.
 */
const getAllEnums = (context: EmitContext): Enum[] => {
  const enums: Enum[] = [];

  navigateProgram(context.program, {
    enum(en) {
      if (
        en.namespace?.name !== "TypeSpec" &&
        en.namespace?.name !== "Drizzle" &&
        en.namespace?.name !== "Reflection"
      )
        enums.push(en);
    },
  });

  return enums;
};

/**
 * Find target model from a type reference.
 */
const findTargetModel = (
  type: Type,
  modelMap: Map<string, Model>,
): Model | undefined => {
  if (type.kind === "Model") {
    const model = type as Model;

    if (model.name === "Array" && model.indexer?.value?.kind === "Model")
      return modelMap.get((model.indexer.value as Model).name.toLowerCase());

    return modelMap.get(model.name.toLowerCase());
  }

  return undefined;
};

/**
 * Check if a type is a string/text scalar.
 */
const isStringType = (type: Type): boolean =>
  type.kind === "Scalar" && (type as Scalar).name === "string";

/**
 * Check if a type is an integer scalar.
 */
const isIntegerType = (type: Type): boolean => {
  if (type.kind !== "Scalar") return false;

  const name = (type as Scalar).name;

  return [
    "int8",
    "int16",
    "int32",
    "int64",
    "uint8",
    "uint16",
    "uint32",
    "safeint",
  ].includes(name);
};

// relationship analysis

/**
 * Get the first element from an array or return the value if not an array.
 */
const getFirstField = (
  fields: string | string[] | undefined,
): string | undefined => (Array.isArray(fields) ? fields[0] : fields);

/**
 * Check if a field looks like a foreign key and return referenced model info.
 */
const analyzeForeignKeyField = (
  fieldName: string,
  _field: ModelProperty,
  modelMap: Map<string, Model>,
): { referencedModel: Model } | null => {
  const lowerFieldName = fieldName.toLowerCase();

  const patterns = [/^(.+)id$/, /^(.+)_id$/, /^id_(.+)$/];

  for (const pattern of patterns) {
    const match = lowerFieldName.match(pattern);

    if (match) {
      const referencedTableName = match[1].toLowerCase();
      const referencedModel = modelMap.get(referencedTableName);

      if (referencedModel) return { referencedModel };

      const singularName = referencedTableName.replace(/s$/, "");
      const pluralName = `${referencedTableName}s`;

      const singularModel = modelMap.get(singularName);

      if (singularModel) return { referencedModel: singularModel };

      const pluralModel = modelMap.get(pluralName);

      if (pluralModel) return { referencedModel: pluralModel };
    }
  }

  return null;
};

/**
 * Check if a model is likely a junction table.
 */
const isJunctionTable = (model: Model): boolean => {
  const props = Array.from(model.properties.entries());

  if (props.length < 2 || props.length > 5) return false;

  const foreignKeyCount = props.filter(
    ([name, prop]) =>
      (isStringType(prop.type) || isIntegerType(prop.type)) &&
      name.toLowerCase().endsWith("id"),
  ).length;

  return foreignKeyCount >= 2;
};

/**
 * Analyze a junction table to extract many-to-many relationships.
 */
const analyzeJunctionTable = (
  junctionModel: Model,
  modelMap: Map<string, Model>,
): Relationship[] => {
  const relationships: Relationship[] = [];
  const foreignKeys: { field: string; model: Model }[] = [];

  for (const [propName, prop] of junctionModel.properties.entries()) {
    if (!isStringType(prop.type) && !isIntegerType(prop.type)) continue;

    const foreignKeyInfo = analyzeForeignKeyField(propName, prop, modelMap);

    if (foreignKeyInfo)
      foreignKeys.push({
        field: propName,
        model: foreignKeyInfo.referencedModel,
      });
  }

  if (foreignKeys.length >= 2) {
    const model1 = foreignKeys[0].model;
    const model2 = foreignKeys[1].model;

    relationships.push({
      type: "many-to-many",
      fromModel: model1,
      toModel: model2,
      junctionTable: junctionModel,
      fromField: foreignKeys[0].field,
      toField: foreignKeys[1].field,
    });

    relationships.push({
      type: "many-to-many",
      fromModel: model2,
      toModel: model1,
      junctionTable: junctionModel,
      fromField: foreignKeys[1].field,
      toField: foreignKeys[0].field,
    });
  }

  return relationships;
};

/**
 * Analyze decorator-defined relationship on a property.
 */
const analyzeDecoratorRelationship = (
  model: Model,
  propName: string,
  prop: ModelProperty,
  context: EmitContext,
  modelMap: Map<string, Model>,
): Relationship | null => {
  if (isOneToOne(context.program, prop)) {
    const options = getRelationOptions(context.program, prop) as
      | RelationOptions
      | undefined;
    const targetModel = findTargetModel(prop.type, modelMap);

    if (targetModel)
      return {
        type: "one-to-one",
        fromModel: model,
        toModel: targetModel,
        fromField: getFirstField(options?.fields) || propName,
        toField: getFirstField(options?.references) || "id",
        relationName: propName,
        onDelete: options?.onDelete,
        onUpdate: options?.onUpdate,
      };
  } else if (isOneToMany(context.program, prop)) {
    const options = getRelationOptions(context.program, prop) as
      | RelationOptions
      | undefined;
    const targetModel = findTargetModel(prop.type, modelMap);

    if (targetModel)
      return {
        type: "one-to-many",
        fromModel: model,
        toModel: targetModel,
        fromField: getFirstField(options?.fields) || propName,
        toField: getFirstField(options?.references) || "id",
        relationName: propName,
        onDelete: options?.onDelete,
        onUpdate: options?.onUpdate,
      };
  } else if (isManyToOne(context.program, prop)) {
    const options = getRelationOptions(context.program, prop) as
      | RelationOptions
      | undefined;
    const targetModel = findTargetModel(prop.type, modelMap);

    if (targetModel)
      return {
        type: "one-to-many",
        fromModel: targetModel,
        toModel: model,
        fromField: getFirstField(options?.references) || "id",
        toField: getFirstField(options?.fields) || propName,
        relationName: propName,
        onDelete: options?.onDelete,
        onUpdate: options?.onUpdate,
      };
  } else if (isManyToMany(context.program, prop)) {
    const options = getRelationOptions(context.program, prop) as
      | ManyToManyOptions
      | undefined;
    const targetModel = findTargetModel(prop.type, modelMap);
    const junctionModel = options?.through
      ? modelMap.get(options.through.toLowerCase())
      : undefined;

    if (targetModel && junctionModel)
      return {
        type: "many-to-many",
        fromModel: model,
        toModel: targetModel,
        junctionTable: junctionModel,
        fromField: options?.foreignKey || `${model.name.toLowerCase()}Id`,
        toField:
          getFirstField(options?.references) ||
          `${targetModel.name.toLowerCase()}Id`,
        relationName: propName,
        onDelete: options?.onDelete,
        onUpdate: options?.onUpdate,
      };
  }

  return null;
};

/**
 * Analyze models to detect relationships using decorators and conventions.
 */
const analyzeRelationships = (
  models: Model[],
  context: EmitContext,
): Relationship[] => {
  const relationships: Relationship[] = [];
  const modelMap = new Map(models.map((m) => [m.name.toLowerCase(), m]));
  const processedJunctions = new Set<string>();

  for (const model of models) {
    for (const [propName, prop] of model.properties.entries()) {
      const decoratorRel = analyzeDecoratorRelationship(
        model,
        propName,
        prop,
        context,
        modelMap,
      );

      if (decoratorRel) {
        relationships.push(decoratorRel);
        continue;
      }

      if (isStringType(prop.type) || isIntegerType(prop.type)) {
        const foreignKeyInfo = analyzeForeignKeyField(propName, prop, modelMap);

        if (foreignKeyInfo) {
          if (
            (isJunction(context.program, model) || isJunctionTable(model)) &&
            !processedJunctions.has(model.name)
          ) {
            processedJunctions.add(model.name);

            const junctionRels = analyzeJunctionTable(model, modelMap);

            relationships.push(...junctionRels);
          } else if (
            !isJunction(context.program, model) &&
            !isJunctionTable(model)
          ) {
            relationships.push({
              type: "one-to-many",
              fromModel: foreignKeyInfo.referencedModel,
              toModel: model,
              fromField: undefined,
              toField: propName,
            });
          }
        }
      }
    }
  }

  return relationships;
};

// code generation

/**
 * Generate pgEnum declaration.
 */
const generateEnumDeclaration = (en: Enum, imports: ImportTracker): string => {
  imports.addPgCore("pgEnum");

  const enumName = en.name.charAt(0).toLowerCase() + en.name.slice(1);
  const tableName = en.name.toLowerCase();
  const members = Array.from(en.members.keys())
    .map((m) => `'${m}'`)
    .join(", ");

  return `export const ${enumName}Enum = pgEnum('${tableName}', [${members}]);`;
};

/**
 * Generate FK action options string.
 */
const generateFkActions = (
  onDelete?: ForeignKeyAction,
  onUpdate?: ForeignKeyAction,
): string => {
  const actions: string[] = [];

  if (onDelete) actions.push(`onDelete: '${onDelete}'`);
  if (onUpdate) actions.push(`onUpdate: '${onUpdate}'`);

  return actions.length > 0 ? `, { ${actions.join(", ")} }` : "";
};

/**
 * Generate Drizzle column definition for a model property.
 */
const generateDrizzleColumn = (
  property: ModelProperty,
  context: EmitContext,
  imports: ImportTracker,
  modelMap: Map<string, Model>,
  relationships: Relationship[],
): string => {
  const columnName = getColumnName(context.program, property);
  const isPrimary = isPrimaryKey(context.program, property);
  const isAuto = isAutoIncrement(context.program, property);
  const hasUuid = isUuid(context.program, property);
  const uuidOptions = getUuidOptions(context.program, property);
  const defaultValue = getDefaultValue(context.program, property);
  const sqlExpression = getSqlExpression(context.program, property);
  const isUniqueCol = isUnique(context.program, property);
  const uniqueOptions = getUniqueOptions(context.program, property);

  let drizzleType: string;

  if (hasUuid) {
    drizzleType = "uuid";
    imports.addPgCore("uuid");
  } else if (property.type.kind === "Enum") {
    const enumName = (property.type as Enum).name;
    drizzleType = `${enumName.charAt(0).toLowerCase() + enumName.slice(1)}Enum`;
  } else {
    drizzleType = mapTypeToDrizzle(property.type, imports);
  }

  let columnDef = `${drizzleType}('${columnName}')`;

  const foreignKeyInfo = analyzeForeignKeyField(
    property.name,
    property,
    modelMap,
  );
  const matchingRel = relationships.find(
    (rel) =>
      rel.toModel.name === property.model?.name &&
      rel.toField === property.name,
  );

  if (foreignKeyInfo && matchingRel) {
    const refTableVar = `${foreignKeyInfo.referencedModel.name.toLowerCase()}Table`;
    const fkActions = generateFkActions(
      matchingRel.onDelete,
      matchingRel.onUpdate,
    );

    columnDef += `.references(() => ${refTableVar}.id${fkActions})`;
  }

  if (isPrimary) {
    columnDef += ".primaryKey()";

    if (isAuto) {
      columnDef += ".generatedAlwaysAsIdentity()";
    } else if (hasUuid && uuidOptions?.defaultRandom) {
      columnDef += ".defaultRandom()";
    }
  } else {
    if (!property.optional) columnDef += ".notNull()";

    if (hasUuid && uuidOptions?.defaultRandom) columnDef += ".defaultRandom()";
  }

  if (sqlExpression) {
    imports.needsSql();
    columnDef += `.default(sql\`${sqlExpression}\`)`;
  } else if (defaultValue !== undefined) {
    if (typeof defaultValue === "string") {
      if (defaultValue === "now()" || defaultValue === "CURRENT_TIMESTAMP") {
        columnDef += ".defaultNow()";
      } else if (defaultValue.startsWith("'") && defaultValue.endsWith("'")) {
        columnDef += `.default(${defaultValue})`;
      } else if (/^\d+(\.\d+)?$/.test(defaultValue)) {
        columnDef += `.default(${defaultValue})`;
      } else if (defaultValue === "true" || defaultValue === "false") {
        columnDef += `.default(${defaultValue})`;
      } else {
        imports.needsSql();
        columnDef += `.default(sql\`${defaultValue}\`)`;
      }
    } else if (typeof defaultValue === "number") {
      columnDef += `.default(${defaultValue})`;
    } else if (typeof defaultValue === "boolean") {
      columnDef += `.default(${defaultValue})`;
    }
  }

  if (isUniqueCol) {
    if (uniqueOptions?.name) {
      columnDef += `.unique('${uniqueOptions.name}')`;
    } else {
      columnDef += ".unique()";
    }
  }

  return columnDef;
};

/**
 * Generate Drizzle table definition for a TypeSpec model.
 */
const generateDrizzleTable = (
  model: Model,
  context: EmitContext,
  imports: ImportTracker,
  modelMap: Map<string, Model>,
  relationships: Relationship[],
): string => {
  imports.addPgCore("pgTable");

  const tableName = getTableName(context.program, model);
  const tableVarName = `${model.name.toLowerCase()}Table`;
  const tableOptions = getTableOptions(context.program, model);
  const compositeId = getCompositeId(context.program, model);

  const columns = Array.from(model.properties.values())
    .filter((prop) => {
      if (prop.type.kind === "Model") {
        const propModel = prop.type as Model;

        if (propModel.name === "Array") return false;
        if (modelMap.has(propModel.name.toLowerCase())) return false;
      }

      return true;
    })
    .map(
      (prop) =>
        `  ${prop.name}: ${generateDrizzleColumn(prop, context, imports, modelMap, relationships)},`,
    )
    .join("\n");

  const schemaPrefix = tableOptions?.schema ? `${tableOptions.schema}.` : "";
  const fullTableName = schemaPrefix + tableName;

  const tableCallbackParts: string[] = [];

  if (compositeId) {
    imports.addPgCore("primaryKey");

    const fieldsStr = compositeId.fields.map((f) => `table.${f}`).join(", ");
    const name = compositeId.name ? `, { name: '${compositeId.name}' }` : "";

    tableCallbackParts.push(
      `pk: primaryKey({ columns: [${fieldsStr}]${name} })`,
    );
  }

  for (const prop of model.properties.values()) {
    if (isIndexed(context.program, prop)) {
      const indexOpts = getIndexOptions(context.program, prop);
      const indexName = indexOpts?.name || `${tableName}_${prop.name}_idx`;

      if (indexOpts?.expression) {
        imports.addPgCore("index");
        imports.needsSql();

        tableCallbackParts.push(
          `${prop.name}Idx: index('${indexName}').on(sql\`${indexOpts.expression}\`)`,
        );
      } else {
        imports.addPgCore("index");

        tableCallbackParts.push(
          `${prop.name}Idx: index('${indexName}').on(table.${prop.name})`,
        );
      }
    }
  }

  let tableDef = `export const ${tableVarName} = pgTable('${fullTableName}', {\n${columns}\n}`;

  if (tableCallbackParts.length > 0)
    tableDef += `, (table) => ({\n  ${tableCallbackParts.join(",\n  ")}\n})`;

  tableDef += ");";

  tableDef += `\n\nexport type ${model.name} = typeof ${tableVarName}.$inferSelect;`;
  tableDef += `\nexport type New${model.name} = typeof ${tableVarName}.$inferInsert;`;

  return tableDef;
};

/**
 * Generate Drizzle relations definition for a model.
 */
const generateDrizzleRelations = (
  model: Model,
  relationships: Relationship[],
  _context: EmitContext,
  imports: ImportTracker,
): string | null => {
  const tableName = model.name.toLowerCase();
  const relationVarName = `${tableName}Relations`;
  const tableVarName = `${tableName}Table`;

  const oneRelations = new Map<string, string>();
  const manyRelations = new Map<string, string>();

  const modelRelationships = relationships.filter(
    (rel) => rel.fromModel === model,
  );

  for (const rel of modelRelationships) {
    const targetTableName = rel.toModel.name.toLowerCase();
    const targetTableVar = `${targetTableName}Table`;

    if (rel.type === "many-to-many" && rel.junctionTable) {
      const junctionTableName = rel.junctionTable.name.toLowerCase();
      const junctionTableVar = `${junctionTableName}Table`;
      const relationName = rel.relationName || `${targetTableName}s`;

      manyRelations.set(
        relationName,
        `  ${relationName}: many(${junctionTableVar}),`,
      );
    } else if (rel.type === "one-to-many") {
      const relationName = rel.relationName || `${targetTableName}s`;

      manyRelations.set(
        relationName,
        `  ${relationName}: many(${targetTableVar}),`,
      );
    }
  }

  const reverseRelationships = relationships.filter(
    (rel) => rel.toModel === model,
  );

  for (const rel of reverseRelationships) {
    if (rel.type === "many-to-many") continue;

    const sourceTableName = rel.fromModel.name.toLowerCase();
    const sourceTableVar = `${sourceTableName}Table`;
    const relationName = rel.relationName || sourceTableName;
    const foreignKeyField = rel.toField || `${sourceTableName}Id`;

    oneRelations.set(
      relationName,
      `  ${relationName}: one(${sourceTableVar}, {
    fields: [${tableVarName}.${foreignKeyField}],
    references: [${sourceTableVar}.id],
  }),`,
    );
  }

  const allRelations = [...oneRelations.values(), ...manyRelations.values()];

  if (allRelations.length === 0) return null;

  imports.needsRelations();

  const needsOne = oneRelations.size > 0;
  const needsMany = manyRelations.size > 0;

  let destructuredParams = "({ ";
  if (needsOne) destructuredParams += "one";
  if (needsOne && needsMany) destructuredParams += ", ";
  if (needsMany) destructuredParams += "many";
  destructuredParams += " })";

  return `export const ${relationVarName} = relations(${tableVarName}, ${destructuredParams} => ({
${allRelations.join("\n")}
}));`;
};

/**
 * Generate relations for junction tables.
 */
const generateJunctionTableRelations = (
  junctionModel: Model,
  relationships: Relationship[],
  imports: ImportTracker,
): string | null => {
  const tableName = junctionModel.name.toLowerCase();
  const relationVarName = `${tableName}Relations`;
  const tableVarName = `${tableName}Table`;

  const foreignKeys: { field: string; model: Model }[] = [];

  for (const [propName, prop] of junctionModel.properties.entries()) {
    if (!isStringType(prop.type) && !isIntegerType(prop.type)) continue;

    const modelMap = new Map(
      relationships.flatMap((r) => [
        [r.fromModel.name.toLowerCase(), r.fromModel],
        [r.toModel.name.toLowerCase(), r.toModel],
      ]),
    );

    const foreignKeyInfo = analyzeForeignKeyField(propName, prop, modelMap);

    if (foreignKeyInfo)
      foreignKeys.push({
        field: propName,
        model: foreignKeyInfo.referencedModel,
      });
  }

  if (foreignKeys.length < 2) return null;

  imports.needsRelations();

  const oneRelations: string[] = [];

  for (const fk of foreignKeys) {
    const targetTableName = fk.model.name.toLowerCase();
    const targetTableVar = `${targetTableName}Table`;
    const relationName = targetTableName;

    oneRelations.push(`  ${relationName}: one(${targetTableVar}, {
    fields: [${tableVarName}.${fk.field}],
    references: [${targetTableVar}.id],
  }),`);
  }

  return `export const ${relationVarName} = relations(${tableVarName}, ({ one }) => ({
${oneRelations.join("\n")}
}));`;
};

// main emitter

/**
 * Emitter entry point.
 */
export const $onEmit = async (ctx: EmitContext): Promise<void> => {
  if (ctx.program.compilerOptions.noEmit) return;

  const imports = new ImportTracker();
  const models = getAllModels(ctx);
  const enums = getAllEnums(ctx);
  const modelMap = new Map(models.map((m) => [m.name.toLowerCase(), m]));
  const relationships = analyzeRelationships(models, ctx);
  const hasRelations = relationships.length > 0;

  const enumDeclarations = enums
    .map((en) => generateEnumDeclaration(en, imports))
    .join("\n\n");

  const tableDeclarations = models
    .map((model) =>
      generateDrizzleTable(model, ctx, imports, modelMap, relationships),
    )
    .join("\n\n");

  const relationDeclarations = models
    .map((model) => {
      if (isJunction(ctx.program, model) || isJunctionTable(model))
        return generateJunctionTableRelations(model, relationships, imports);

      return generateDrizzleRelations(model, relationships, ctx, imports);
    })
    .filter((rel) => rel !== null)
    .join("\n\n");

  const schemaContent =
    models.length > 0 || enums.length > 0
      ? `// generated drizzle schema from typespec
${imports.generate()}

${enums.length > 0 ? `// enums\n${enumDeclarations}\n\n` : ""}// tables
${tableDeclarations}

${hasRelations ? `// relations\n${relationDeclarations}\n` : ""}`
      : `// no models found in typespec program
// add @table decorated models to generate drizzle tables
`;

  const indexContent = `// generated exports
export * from './schema.js';
`;

  await writeOutput(
    ctx.program,
    <Output>
      <SourceDirectory path="src">
        <SourceFile path="schema.ts" filetype="ts">
          {schemaContent}
        </SourceFile>
        <SourceFile path="index.ts" filetype="ts">
          {indexContent}
        </SourceFile>
      </SourceDirectory>
    </Output>,
    ctx.emitterOutputDir,
  );
};
