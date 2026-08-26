-- `%.%#` == `.*`

-- Python Options:
--   -t     : issue warnings about inconsistent tab usage (-tt: issue errors)
--   -u     : force the stdout and stderr streams to be unbuffered so output
--            shows in vim immediately.
--
-- Filtering messages
--
-- If you have a compiler that produces error messages that do not fit in the
-- format string, you could write a program that translates the error messages
-- into this format.  You can use this program with the ":make" command by
-- changing the 'makeprg' option.  For example: >
--    :set mp=make\ \\\|&\ error_filter

if ON_WINDOWS then
  -- vim.cmd [[CompilerSet makeprg=C:\Users\Philipp\proj\gi-nk\.venv\gi-nk\Scripts\python.exe]]
  vim.cmd [[CompilerSet makeprg=python.exe]]
else
  vim.cmd [[CompilerSet makeprg=make]]
end

-- Drop frames inside third-party (pip-installed) packages entirely -- they
-- always live under a directory literally named "site-packages" regardless
-- of OS/venv tool. Must come after the general %A rule below, would
-- otherwise match these lines too (errorformat tries rules top-to-bottom per
-- line)
-- Pattern breakdown:
--   %-G            ignore/discard this line entirely (not added to the list)
--   %\s%#          zero or more leading whitespace characters
--   File "         literal text
--   %.%#           ".*" wildcard -- matches any prefix of the path
--   site-packages  literal text that must appear somewhere in the path
--   %.%#           ".*" wildcard -- matches the rest of the path/filename
--   ", line        literal text
--   %.%#           ".*" -- consumes the rest of the line (line number,
--                  ", in ..."); no %l capture needed, this line is discarded
vim.cmd [[CompilerSet errorformat=%-G%\\s%#File\ \"%.%#site-packages%.%#\"\\,\ line\ %.%#]]
-- Also drop stdlib frames (fi. socket.py, http/client.py when a library call
-- eventually hits the network stack) -- confirmed necessary against a real
-- chained requests.exceptions.ConnectionError traceback, which routes
-- through /usr/lib/python3.12/... well outside any site-packages dir.
-- Catches both stdlib (.../lib/python3.12/socket.py) and, redundantly with
-- the rule above, most Unix-style site-packages paths too, since both
-- contain "lib/python" -- kept as a separate rule since Windows
-- site-packages paths (...\Lib\site-packages\...) don't.
-- Pattern breakdown: identical shape to the site-packages rule above, just
-- with "lib/python" as the required substring instead.
vim.cmd [[CompilerSet errorformat+=%-G%\\s%#File\ \"%.%#lib/python%.%#\"\\,\ line\ %.%#]]
-- Use each file and line of Tracebacks (to see and step through the code executing).
-- Must come after 'site-packages' and 'lib/python' removing.
-- Pattern breakdown (backslashes below are only needed because this whole
-- string is passed through `:CompilerSet`, an Ex command, where spaces/
-- quotes must be escaped -- they're not part of the errorformat syntax
-- itself):
--   %A        start of a new (possibly multi-line) entry; "any" type
--   %\s%#     zero or more leading whitespace characters
--   File "    literal text
--   %f        captures the file path
--   ", line   literal text
--   %l        captures the line number
--   , in      literal text
--   %.%#      "%." = any single char, "%#" = 0-or-more of the preceding atom,
--             i.e. ".*" -- consumes the rest of the line (the function/
--             module name after "in"), uncaptured since it's not needed
vim.cmd [[CompilerSet errorformat+=%A%\\s%#File\ \"%f\"\\,\ line\ %l\\,\ in%.%#]]

-- Include failed toplevel doctest example.
-- Pattern breakdown:
--   %+C              continuation of the previous multi-line entry, and
--                    INCLUDE this line's text in the aggregated message
--                    ("+" = include, vs "-C" below which continues but
--                    discards the line's text)
--   Failed example:  literal text
--   %.%#             ".*" -- consumes the rest of the line
vim.cmd [[CompilerSet errorformat+=%+CFailed\ example:%.%#]]
-- Ignore big star lines from doctests.
-- Pattern breakdown:
--   %-G       ignore/discard this line
--   *         literal asterisk character
--   %\{70%\}  Vim regex "\{70}" applied to the preceding atom: repeat it
--             exactly 70 times -- matches a line of exactly 70 asterisks
--             (doctest's summary separator line)
vim.cmd [[CompilerSet errorformat+=%-G*%\\{70%\\}]]
-- Ignore most of doctest summary. x2
-- Pattern breakdown (first line, fi. "3 items had failures:"):
--   %-G     ignore/discard this line
--   %*\d    a number (one or more digits), uncaptured -- scanf-style
--           shorthand equivalent to "\d\+"
--   " items had failures:"   literal text
vim.cmd [[CompilerSet errorformat+=%-G%*\\d\ items\ had\ failures:]]
-- Pattern breakdown (second line, fi. "   3 of  10 in module"):
--   %-G     ignore/discard this line
--   %*\s    one or more whitespace characters, uncaptured
--   %*\d    a number, uncaptured
--   " of"   literal text
--   %*\s    one or more whitespace characters, uncaptured
--   %*\d    a number, uncaptured
--   " in"   literal text
--   %.%#    ".*" -- consumes the rest of the line
vim.cmd [[CompilerSet errorformat+=%-G%*\\s%*\\d\ of%*\\s%*\\d\ in%.%#]]

-- -- SyntaxErrors (%p is for the pointer to the error column).
-- -- Source: http://www.vim.org/scripts/script.php?script_id=477
-- vim.cmd [[CompilerSet errorformat+=%E\ \ File\ \"%f\"\\\,\ line\ %l]]
-- -- %p must come before other lines that might match leading whitespace
-- vim.cmd [[CompilerSet errorformat+=%-C%p^]]
-- vim.cmd [[CompilerSet errorformat+=%+C\ \ %m]]
-- vim.cmd [[CompilerSet errorformat+=%Z\ \ %m]]
