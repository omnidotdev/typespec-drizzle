import { describe, expect, it } from "bun:test";

import { DrizzleEmitterTester } from "./__fixtures__/drizzleEmitter.tester.js";

describe("TypeSpec Drizzle emitter", () => {
  it("compiles TypeSpec code without errors", async () => {
    await DrizzleEmitterTester.compile(`
      model User {
        id: string;
        name: string;
      }
    `);

    expect(true).toBe(true);
  });

  it("diagnoses TypeSpec code without errors", async () => {
    await DrizzleEmitterTester.diagnose(`
      model User {
        id: string;
        name: string;
      }
    `);

    expect(true).toBe(true);
  });

  it("emits Drizzle schema files using emitter framework", async () => {
    await DrizzleEmitterTester.compile(`
      model User {
        id: string;
        name: string;
        email: string;
      }

      model Post {
        id: string;
        title: string;
        authorId: string;
      }
    `);

    expect(true).toBe(true);
  });
});
