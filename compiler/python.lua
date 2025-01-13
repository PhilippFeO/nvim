-- TODO: Only if Makefile exists <13-05-2024>

-- `%.%#` == `.*`

vim.cmd('CompilerSet makeprg=make')
-- Ignore following pytest line (emerges if test is decorated with '@pytest.mark.skip')
-- SKIPPED [1] tests/transfer_files_test.py|77| unconditional skip
-- ^=: prepend to string
-- %-G: ignore
vim.cmd('CompilerSet errorformat^=%-GSKIPPED%.%#')
-- Ignore logging.LOGLEVEL output, fi:
-- [INFO:  01.01.2025  11:56:50  add_description]  Orientation: Horizontal (normal)
vim.cmd('CompilerSet errorformat^=%-G[INFO:%.%#')
vim.cmd('CompilerSet errorformat^=%-G[WARNING:%.%#')
vim.cmd('CompilerSet errorformat^=%-G2025%.%#')
-- s. `h errorformat-multi-line`
vim.cmd [[CompilerSet errorformat+=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m]]
