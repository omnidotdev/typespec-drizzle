import { createTypeSpecLibrary } from "@typespec/compiler";

/**
 * Initiate the TypeSpec library.
 */
export const $lib = createTypeSpecLibrary({
  name: "typespec-drizzle-emitter",
  diagnostics: {},
});

export const { reportDiagnostic, createDiagnostic } = $lib;
