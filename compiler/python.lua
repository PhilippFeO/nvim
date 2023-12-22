-- TODO: setting current_compiler as described in `h current_compiler` doesn't work <22-12-2023>

-- Due to compatability reasons with older Vim versions better use CompilerSet than vim.bo.makeprg directly
-- But since I won't publish my plugin, in principle I dont have to care
vim.cmd.CompilerSet('makeprg=python3')
-- from `h errorformat`
vim.cmd.CompilerSet([[errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m]])

vim.o.autowrite = true
