import { fileURLToPath } from "node:url";
import { resolvePath } from "@typespec/compiler";
import { createTester } from "@typespec/compiler/testing";

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
