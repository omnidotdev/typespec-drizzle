import { resolvePath } from "@typespec/compiler";
import { createTester } from "@typespec/compiler/testing";
import { fileURLToPath } from "url";

/**
 * Drizzle emitter tester. Functionally serves as a test fixture.
 * @see https://typespec.io/docs/extending-typespec/testing/#tester-api
 */
export const DrizzleEmitterTester = createTester(
  resolvePath(fileURLToPath(import.meta.url), "../../../../"),
  {
    libraries: ["@omnidotdev/typespec-drizzle-emitter"],
  },
).importLibraries();
