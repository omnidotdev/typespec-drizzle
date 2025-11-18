load("ext://dotenv", "dotenv")
dotenv()

local_resource(
  "install",
  "bun install",
)

local_resource(
  "build",
  "bun run build",
  auto_init=False,
  trigger_mode=TRIGGER_MODE_MANUAL
)

local_resource(
  "build:watch",
  serve_cmd="bun build:watch",
  auto_init=False,
  trigger_mode=TRIGGER_MODE_MANUAL
)

local_resource(
  "test",
  "bun test",
  auto_init=False,
  trigger_mode=TRIGGER_MODE_MANUAL
)
