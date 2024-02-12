-- Don't forget `vim.cmd.compiler('sh')` in ftplugin/sh.lua
vim.cmd.CompilerSet('makeprg=bash')
vim.o.errorformat = [[%f: line %l: %m]]
