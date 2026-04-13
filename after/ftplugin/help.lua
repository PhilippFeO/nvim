vim.treesitter.start()

-- These option, although set in plugin/options.lua aren't applied to help pages. Only god knows why.
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 8 -- s. plugin/options.lua

vim.keymap.set('n', 'K', '<C-]>', {
    desc = 'Jump to tag under cursor',
    remap = true,
})
