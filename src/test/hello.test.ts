import { describe, it, expect } from "bun:test";

import { DrizzleEmitterTester } from "./__fixtures__/drizzleEmitter.tester.js";

describe("TypeSpec Drizzle emitter", () => {
  it("compiles TypeSpec code without errors", async () => {
    await DrizzleEmitterTester.compile(`
      model User {
        id: string;
        name: string;
      }

      op getUser(id: string): User;
    `);

    // NB: assertion is implicit, if above works, the test passes
  });

  it("diagnoses TypeSpec code without errors", async () => {
    const diagnostics = await DrizzleEmitterTester.diagnose(`
      model User {
        id: string;
        name: string;
      }

      op getUser(id: string): User;
    `);

    expect(diagnostics).toHaveLength(0);
  });
});
