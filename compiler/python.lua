-- TODO: setting current_compiler as described in `h current_compiler` doesn't work <22-12-2023>
-- TODO: For parsing errors with stacktrace https://vi.stackexchange.com/questions/5110/quickfix-support-for-python-tracebacks might help <03-01-2024>

-- Due to compatability reasons with older Vim versions better use CompilerSet than vim.bo.makeprg directly
-- But since I won't publish my plugin, in principle I dont have to care
-- vim.cmd.CompilerSet('makeprg=~/dotfiles/nvim/compiler/parse_python_error.sh')

-- TODO: Good idea to use `h CompilerSet` for errorformat? <30-01-30-0130-01-2024
-- I barely understand `h CompilerSet`
-- vim.cmd.CompilerSet([[errorformat=File\ \"%f\"\\,\ line\ %l\\,\ in\ <%.%#>\ %m]])
vim.bo.errorformat = [[File\ \"%f\"\\,\ line\ %l\\,\ in\ <%.%#>\ %m]]


vim.o.autowrite = true
