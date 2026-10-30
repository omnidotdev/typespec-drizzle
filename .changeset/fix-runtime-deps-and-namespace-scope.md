---
"@omnidotdev/typespec-drizzle": patch
---

fix: declare ts-pattern as a runtime dependency and stop emitting library types

`ts-pattern` was only a devDependency, so the published package shipped no runtime dependencies and failed to load with `Cannot find package 'ts-pattern'` when installed standalone. It is now a regular dependency.

The built-in type filter only excluded the exact `TypeSpec` namespace, so library types nested in sub-namespaces (e.g. `TypeSpec.Http`) leaked into the generated schema as spurious enums and tables. The filter now walks the namespace ancestry, so only the user's own types are emitted.
