-- -- TODO: Only if Makefile exists <13-05-2024>
--
-- -- `%.%#` == `.*`
--
-- vim.cmd('CompilerSet makeprg=make')
-- -- Ignore following pytest line (emerges if test is decorated with '@pytest.mark.skip')
-- -- SKIPPED [1] tests/transfer_files_test.py|77| unconditional skip
-- -- ^=: prepend to string
-- -- %-G: ignore
-- vim.cmd('CompilerSet errorformat^=%-GSKIPPED%.%#')
-- -- Ignore logging.LOGLEVEL output, fi:
-- -- [INFO:  01.01.2025  11:56:50  add_description]  Orientation: Horizontal (normal)
-- vim.cmd('CompilerSet errorformat^=%-G[INFO:%.%#')
-- vim.cmd('CompilerSet errorformat^=%-G[WARNING:%.%#')
-- vim.cmd('CompilerSet errorformat^=%-G2025%.%#')
-- -- Ignore Output starting with a number
-- -- used within open_meteo
-- vim.cmd('CompilerSet errorformat^=%-G%*[0-9]%.%#')
-- -- s. `h errorformat-multi-line`
-- --   File "/localhome/rost_ph/python/tree-sitter-callgraph/parser_ts/enriched_node.py", line 189, in __init__
-- -- vim.cmd [[CompilerSet errorformat+=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m]]
-- vim.cmd [[CompilerSet errorformat+=%C\ %.%#,%A\ \ File\ \"/localhome/rost_ph/python/tree-sitter-callgraph/parser_ts/%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m]]
-- vim.cmd [[CompilerSet errorformat+=%E\ \ \ \ File\ \"%f\"\\,\ line\ %l%.%#,\ in\ %.%#]]

-- Options:
--   -t     : issue warnings about inconsistent tab usage (-tt: issue errors)
--   -u     : force the stdout and stderr streams to be unbuffered so output
--            shows in vim immediately.
--
-- Consider:
--   -3     : warn about Python 3.x incompatibilities that 2to3 cannot
--            trivially fix
--
-- Filtering messages
--
-- If you have a compiler that produces error messages that do not fit in the
-- format string, you could write a program that translates the error messages
-- into this format.  You can use this program with the ":make" command by
-- changing the 'makeprg' option.  For example: >
--    :set mp=make\ \\\|&\ error_filter

vim.cmd [[CompilerSet makeprg=make]]

-- Use each file and line of Tracebacks (to see and step through the code executing).
vim.cmd [[CompilerSet errorformat=%A%\\s%#File\ \"%f\"\\,\ line\ %l\\,\ in%.%#]]
-- Include failed toplevel doctest example.
vim.cmd [[CompilerSet errorformat+=%+CFailed\ example:%.%#]]
-- Ignore big star lines from doctests.
vim.cmd [[CompilerSet errorformat+=%-G*%\\{70%\\}]]
-- Ignore most of doctest summary. x2
vim.cmd [[CompilerSet errorformat+=%-G%*\\d\ items\ had\ failures:]]
vim.cmd [[CompilerSet errorformat+=%-G%*\\s%*\\d\ of%*\\s%*\\d\ in%.%#]]

-- SyntaxErrors (%p is for the pointer to the error column).
-- Source: http://www.vim.org/scripts/script.php?script_id=477
vim.cmd [[CompilerSet errorformat+=%E\ \ File\ \"%f\"\\\,\ line\ %l]]
-- %p must come before other lines that might match leading whitespace
vim.cmd [[CompilerSet errorformat+=%-C%p^]]
vim.cmd [[CompilerSet errorformat+=%+C\ \ %m]]
vim.cmd [[CompilerSet errorformat+=%Z\ \ %m]]

-- I don't use \%-G%.%# to remove extra output because most of it is useful as
-- context for the actual error message. I also don't include %+G because
-- they're unnecessary if I'm not squelching most output.
-- If I was using %+G, I'd probably want something like these. There are so
-- many, that I don't bother.
--      \%+GTraceback%.%#,
--      \%+G%*\\wError%.%#,
--      \%+G***Test\ Failed***%.%#
--      \%+GExpected%.%#,
--      \%+GGot:%.%#,

-- let &cpo = s:cpo_save
-- unlet s:cpo_save

-- vim:set sw=2 sts=2:
