-- TODO: setting current_compiler as described in `h current_compiler` doesn't work <22-12-2023>
-- TODO: For parsing errors with stacktrace https://vi.stackexchange.com/questions/5110/quickfix-support-for-python-tracebacks might help <03-01-2024>

-- Due to compatability reasons with older Vim versions better use CompilerSet than vim.bo.makeprg directly
-- But since I won't publish my plugin, in principle I dont have to care
-- `pytest -rs` prints information about as skip marked tests
vim.cmd.CompilerSet([[makeprg=python3\ -m\ pytest \-rs]])
-- from `h errorformat`
vim.cmd.CompilerSet([[errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m]])

vim.o.autowrite = true
