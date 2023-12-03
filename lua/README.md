# lua/ directory #

Scripts in this directory have to be loaded explicitly via `require(SCRIPT)` to become active.
If a folder contains an `init.lua` it also possible to `require(FOLDER)` (and `init.lua` will be loaded automatically).

A advantage is a more precise control over how and when a module is required. For example lay many plugin configurations in `lua/lazy/` and are required in Lazy.nvim's setup process. It wouldn't make sense to place them under `plugin/` because they are needed at exactly this position/time in the loading process. Keeping them in Lazy.nvim's setup function makes it unnecessarily complex.
