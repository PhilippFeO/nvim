-- TODO: Only if Makefile exists <13-05-2024>
vim.cmd('CompilerSet makeprg=make')
-- Ignore following pytest line (emerges if test is decorated with '@pytest.mark.skip')
-- SKIPPED [1] tests/transfer_files_test.py|77| unconditional skip
-- ^=: prepend to string
-- %-G: ignore
vim.cmd('CompilerSet errorformat^=%-GSKIPPED%.%#')
-- s. `h errorformat-multi-line`
vim.cmd [[CompilerSet errorformat+=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m]]
