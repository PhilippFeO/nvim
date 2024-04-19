local release = false
if release then
    vim.o.makeprg = [[make --no-print-directory -C ~/proj/upas-s5p/UPAS-L2/build/release]]
else
    vim.o.makeprg = [[make --no-print-directory -C ~/proj/upas-s5p/UPAS-L2/build/verbose]]
end

-- Verzeichnisabhängige Pfade (bspw. für S4-UPAS: Mit if-else und vim.fn.expand('%:p') arbeiten)

-- Vim is PWD aware when listing the file path in the quickfix list, ie. only the missing part is displayed (fi. /localhome/rost_ph/proj/upas-s5p/ is skipped)
-- Pfade werden relativ zum PWD angezeigt und verarbeitet, Nur '/localhome/' abschneiden geht also nicht
-- Pfad zum Arbeitsverzeichnis eingefügt, da dann ausschließlich UPAS-Dateien „getroffen“ werden (aber nicht die Bibliothektsdateien wie dlib/matrix.h, etc.)
vim.o.errorformat = [[/localhome/rost_ph/proj/upas-s5p/UPAS-L2/src/%f:%l:%c: %m]]

vim.keymap.set('n', '<Leader>cm',
    '<Cmd>!cd ../build && cmake ../src && cd -<CR>',
    { desc = '[cm]ake ../src in build/' })
