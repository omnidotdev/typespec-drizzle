v1alpha1.extension_repo(name='omni', url='https://github.com/omnidotdev/tilt-extensions')
v1alpha1.extension(name='dotenv_values', repo_name='omni', repo_path='dotenv_values')
load('ext://dotenv_values', 'dotenv_values')

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
