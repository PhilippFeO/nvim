-- Verzeichnisabhängige Pfade (bspw. für S4-UPAS: Mit if-else und vim.fn.expand('%:p') arbeiten)
-- Ohne 'true' funktioniert es nicht, schaltet 'Lua-Magic' aus
if string.find(vim.fn.expand('%:p'), 'UPAS-L2', 1, true) then
  local release = false
  local upas_path = vim.fn.expand('~') .. '/proj/upas-s5p/UPAS-L2/'
  local upas_build = upas_path .. 'build/'
  if release then
    -- I thought escaping space is not necessary when using [[…]] but here it is
    vim.cmd('CompilerSet makeprg=make\\ --no-print-directory\\ -C\\ ' .. upas_build .. 'release')
  else
    -- I thought escaping space is not necessary when using [[…]] but here it is
    vim.cmd('CompilerSet makeprg=make\\ --no-print-directory\\ -C\\ ' .. upas_build .. 'verbose')
  end
  -- Vim is PWD aware when listing the file path in the quickfix list, ie. only the missing part is displayed (fi. /localhome/rost_ph/proj/upas-s5p/ is skipped)
  -- Pfade werden relativ zum PWD angezeigt und verarbeitet, Nur '/localhome/' abschneiden geht also nicht
  -- Pfad zum Arbeitsverzeichnis eingefügt, da dann ausschließlich UPAS-Dateien „getroffen“ werden (aber nicht die Bibliothektsdateien wie dlib/matrix.h, etc.)
  local upas_src = upas_path .. 'src/'
  local upas_efm_stump = upas_src .. '%f:%l:%c:\\ '
  vim.cmd('CompilerSet errorformat+=' .. upas_efm_stump .. '%m')
  -- Ignore unused function parameter
  -- ^=: prepend to string
  -- %-G: Ignore
  vim.cmd('CompilerSet errorformat^=%-G' .. upas_efm_stump .. '%tarning:\\ %.%#\\ [-Wunused-parameter]')
  -- Manchmal gibt's weitere Fehlermeldungen bzgl einer XML-Datei. Diese beginnt mit heutigem Datum. Fabian meinte, die könne ich ignorieren.
  vim.cmd('CompilerSet errorformat^=%-G' .. vim.fn.strftime("%Y-%m-%d") .. '%.%#')
  -- Ich benutze diese Variabe aber g++ ist scheinbar zu doof.
  vim.cmd('CompilerSet errorformat^=%-G' ..
    upas_efm_stump .. '%tarning:\\ variable\\ ‘ev’\\ set\\ but\\ not\\ used\\ [-Wunused-but-set-variable]')
else
  vim.cmd([[CompilerSet makeprg=make\ --no-print-directory\ -C\ ../build]])
  -- %:p:h Path without file (and trailing /)
  vim.o.errorformat = vim.fn.expand('%:p:h') .. '/%f:%l:%c: %m'
  vim.cmd('CompilerSet errorformat+=' .. vim.fn.expand('%:p:h') .. '/%f:%l:%c: %m')
end
