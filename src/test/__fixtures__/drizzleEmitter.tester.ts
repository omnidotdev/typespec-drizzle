import type { Diagnostic } from "@typespec/compiler";
import { createTestHost, createTestWrapper } from "@typespec/compiler/testing";
import { DrizzleTestLibrary } from "../../testing/index.js";

/**
 * Drizzle emitter tester. Functionally serves as a test fixture.
 * @see https://typespec.io/docs/extending-typespec/testing/#tester-api
 */
export const DrizzleEmitterTester = {
  async compile(code: string): Promise<{ diagnostics: readonly Diagnostic[] }> {
    const host = await createTestHost({ libraries: [DrizzleTestLibrary] });
    const runner = createTestWrapper(host, {
      autoImports: ["@omnidotdev/typespec-drizzle"],
      autoUsings: ["Drizzle"],
    });
    const diagnostics = await runner.diagnose(code);
    return { diagnostics };
  },

  async diagnose(code: string): Promise<readonly Diagnostic[]> {
    const { diagnostics } = await this.compile(code);
    return diagnostics;
  },
};
