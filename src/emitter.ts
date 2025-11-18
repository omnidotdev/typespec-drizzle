import type { EmitContext } from "@typespec/compiler";
import { emitFile, resolvePath } from "@typespec/compiler";

/**
 * Entry point for the emitter.
 * @param context Emitter context, including the current program being compiled.
 * @see https://typespec.io/docs/extending-typespec/emitters-basics/#onemit
 */
export const $onEmit = async (ctx: EmitContext) => {
  // exit if `noEmit` is enabled
  if (ctx.program.compilerOptions.noEmit) return;

  await emitFile(ctx.program, {
    path: resolvePath(ctx.emitterOutputDir, "output.txt"),
    content: "Hello world\n",
  });
};
