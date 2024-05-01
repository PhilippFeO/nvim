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

  -- Overwrite <Leader>mr-Keymap from plugin/keymaps.lua, because there is no run-target in UPAS
  -- In compiler/cpp.lua to have one 'release' variable. Necessary for 'desc'.
  vim.keymap.set('n', '<Leader>mr',
    '<Cmd>!cd ../build/verbose &&./upas-l2 --so2 /localhome/rost_ph/proj/upas-s5p/UPAS-L2/cobra_data/S5P_RPRO_L1B_IR_UVN_20190622T163826_20190622T181956_08758_03_020100_20220706T041803.nc /localhome/rost_ph/proj/upas-s5p/UPAS-L2/cobra_data/S5P_RPRO_L1B_RA_BD3_20190623T010555_20190623T024725_08763_03_020100_20220706T043411.nc -b 2000 -n 10 -t 12 --aux-cloud /localhome/rost_ph/proj/upas-s5p/UPAS-L2/cobra_data/S5P_RPRO_L2__CLOUD__20190623T010555_20190623T024725_08763_03_020401_20220928T212700.nc --aux-o3 /localhome/rost_ph/proj/upas-s5p/UPAS-L2/cobra_data/S5P_RPRO_L2__O3_____20190623T010555_20190623T024725_08763_03_020401_20221009T192826.nc --aux-tm5 "/localhome/rost_ph/proj/upas-s5p/UPAS-L2/cobra_data/S5P_OPER_AUX_CTMANA_20190623T000000_20190624T000000_20221224T013458.nc /localhome/rost_ph/proj/upas-s5p/UPAS-L2/cobra_data/S5P_OPER_AUX_CTMANA_20190624T000000_20190625T000000_20221224T020347.nc"<CR>',
    { desc = string.format('Run %s-upas', 'release' and release or 'verbose') })
else
  vim.cmd([[CompilerSet makeprg=make\ --no-print-directory\ -C\ ../build]])
  -- %:p:h Path without file (and trailing /)
  vim.o.errorformat = vim.fn.expand('%:p:h') .. '/%f:%l:%c: %m'
  vim.cmd('CompilerSet errorformat+=' .. vim.fn.expand('%:p:h') .. '/%f:%l:%c: %m')
end
