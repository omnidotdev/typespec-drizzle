// Edge cases fixture - Testing edge cases and unusual scenarios for Drizzle generation
namespace EdgeCases;

/** Empty model with only an ID */
model MinimalModel {
  id: string;
}

/** Model with no properties at all (should be handled gracefully) */
model EmptyModel {
}

/** Model with only optional properties */
model AllOptionalModel {
  id?: string;
  name?: string;
  description?: string;
  createdAt?: utcDateTime;
}

/** Model with very long field names */
model LongFieldNamesModel {
  id: string;
  thisIsAVeryLongFieldNameThatMightCauseIssuesWithColumnNaming: string;
  anotherExtremelyLongFieldNameForTestingPurposesOnly: string;
  superLongOptionalFieldThatShouldStillWorkProperly?: string;
}

/** Model with special characters in descriptions and names */
model SpecialCharactersModel {
  /** Field with "quotes" and 'apostrophes' in description */
  id: string;

  /** Field with <brackets> and [square brackets] */
  fieldWithBrackets: string;

  /** Field with & ampersands, % percentages, and # hashes */
  specialCharsField: string;

  /** Field with unicode characters: émojis 🚀, åccents, and çharacters */
  unicodeField?: string;
}

/** Model with reserved SQL keywords as field names */
model ReservedKeywordsModel {
  id: string;
  select: string;
  from: string;
  where: string;
  order: string;
  group: string;
  having: string;
  insert: string;
  update: string;
  delete: string;
  table: string;
  index: string;
  primary: string;
  foreign: string;
  key: string;
  constraint: string;
  unique: string;
  not: string;
  null: string;
  default: string;
}

/** Model with numeric field names (should be handled properly) */
model NumericFieldNamesModel {
  id: string;
  /** Field starting with number */
  field1: string;
  field2: string;
  field3: string;
  /** Field that's all numbers */
  123field: string;
}

/** Model with mixed case field names */
model MixedCaseModel {
  id: string;
  camelCaseField: string;
  PascalCaseField: string;
  snake_case_field: string;
  kebab-case-field: string;
  UPPER_CASE_FIELD: string;
  MiXeD_cAsE_FiElD: string;
}

/** Model with extremely nested namespace */
namespace Deeply.Nested.Namespace.Structure {
  model DeeplyNestedModel {
    id: string;
    name: string;
    value: string;
  }
}

/** Model with circular reference potential */
model NodeModel {
  id: string;
  name: string;
  parentId?: string;
  /** Reference to another NodeModel (self-referential) */
  parentNodeId?: string;
}

/** Model with all possible TypeSpec scalar types */
model AllScalarTypesModel {
  id: string;
  stringField: string;
  int8Field: int8;
  int16Field: int16;
  int32Field: int32;
  int64Field: int64;
  uint8Field: uint8;
  uint16Field: uint16;
  uint32Field: uint32;
  uint64Field: uint64;
  float32Field: float32;
  float64Field: float64;
  booleanField: boolean;
  bytesField: bytes;
  plainDateField: plainDate;
  plainTimeField: plainTime;
  utcDateTimeField: utcDateTime;
  offsetDateTimeField: offsetDateTime;
  durationField: duration;
}

/** Model with array and record types that need special handling */
model ComplexTypesModel {
  id: string;
  /** Simple string array */
  stringArray: string[];
  /** Nested arrays */
  nestedStringArrays: string[][];
  /** Record with string values */
  stringRecord: Record<string>;
  /** Record with complex values */
  complexRecord: Record<unknown>;
  /** Array of records */
  recordArray: Record<string>[];
}

/** Model with template types */
model TemplateModel<T> {
  id: string;
  genericField: T;
  name: string;
}

/** Instantiated template model */
model ConcreteTemplateModel {
  ...TemplateModel<string>;
  additionalField: string;
}

/** Model with extends/inheritance */
model BaseModel {
  id: string;
  createdAt: utcDateTime;
  updatedAt?: utcDateTime;
}

model ExtendedModel extends BaseModel {
  name: string;
  description?: string;
}

/** Model with is relationship (composition) */
model TimestampModel {
  createdAt: utcDateTime;
  updatedAt?: utcDateTime;
}

model ComposedModel {
  id: string;
  name: string;
  ...TimestampModel;
}

/** Model with decorator usage */
@doc("This is a model with decorators")
model DecoratedModel {
  @doc("Primary key field")
  id: string;

  @doc("Required name field")
  name: string;

  @doc("Optional description field")
  description?: string;
}

/** Model with visibility modifiers */
model VisibilityModel {
  id: string;
  publicField: string;
  @visibility("read")
  readOnlyField: string;
  @visibility("write")
  writeOnlyField: string;
  @visibility("never")
  hiddenField: string;
}

/** Model with format annotations */
model FormattedModel {
  id: string;
  @format("email")
  email: string;
  @format("uri")
  website?: string;
  @format("uuid")
  uuid: string;
  @format("date-time")
  timestamp: utcDateTime;
}

/** Model with constraints */
model ConstrainedModel {
  id: string;
  @minLength(1)
  @maxLength(100)
  name: string;
  @minimum(0)
  @maximum(120)
  age?: int32;
  @pattern("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")
  email: string;
}

/** Model that might cause naming conflicts */
model table {
  id: string;
  name: string;
}

model schema {
  id: string;
  definition: string;
}

model database {
  id: string;
  connectionString: string;
}
