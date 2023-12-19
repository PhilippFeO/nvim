-- Due to compatability reasons better use CompilerSet than vim.bo.makeprg
vim.cmd.CompilerSet('makeprg=python3')
-- vim.cmd.CompilerSet([[errorformat=%E||%.%#,%C\ \ \ \ \ File\ \"%f\",\ line\ %l%.%#,%C%.%#%o,%Z%m]])
-- TODO: || entfernen, \s* für Leerzeichen? <19-12-2023>
--      Beispiele für Python-Fehlerformatstrings: https://github.com/idbrii/vim-david/blob/1a0089f30172b19ee084c24a951d337358989801/compiler/python.vim)
vim.cmd.CompilerSet([[errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m]])
