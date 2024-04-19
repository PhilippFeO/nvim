-- Loads RUNTIMEPATH/compiler/python.lua
-- vim.cmd.compiler('bash')

vim.o.makeprg = 'bash'
vim.o.errorformat = [[%f: line %l: %m]]
