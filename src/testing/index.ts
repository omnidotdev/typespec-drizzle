import type { TypeSpecTestLibrary } from "@typespec/compiler/testing";
import {
  createTestLibrary,
  findTestPackageRoot,
} from "@typespec/compiler/testing";

/**
 * Test library.
 */
export const DrizzleTestLibrary: TypeSpecTestLibrary = createTestLibrary({
  name: "@omnidotdev/typespec-drizzle",
  packageRoot: await findTestPackageRoot(import.meta.url),
});
