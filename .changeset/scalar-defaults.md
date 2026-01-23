---
"@omnidotdev/typespec-drizzle": minor
---

Migrate to native TypeSpec scalar defaults. Add `Defaults.uuidv4`, `Defaults.uuidv7`, and `Defaults.currentTimestamp` scalars for setting default values on model properties. Remove custom `@default*` decorators in favor of native TypeSpec default syntax.
