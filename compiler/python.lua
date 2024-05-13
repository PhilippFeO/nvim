-- TODO: Only if Makefile exists <13-05-2024>
vim.cmd('CompilerSet makeprg=make')
-- s. `h errorformat-multi-line`
vim.cmd [[CompilerSet errorformat+=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m]]
