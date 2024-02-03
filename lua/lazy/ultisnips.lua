return {
    'SirVer/ultisnips',
    init = function()
        -- Expands snippets without <A> option
        -- Especially useful for ${VISUAL[:PLACEHOLDER]} snippets
        --  Makes more sense without a ultisnip comletion source/LSP because triggers are proposed by the LSP completion
        vim.g.UltiSnipsExpandTrigger = "<Tab>"
        vim.g.UltiSnipsJumpForwardTrigger = "<c-k>"
        vim.g.UltiSnipsJumpBackwardTrigger = "<c-j>"

        -- If you want :UltiSnipsEdit to split your window.
        vim.g.UltiSnipsEditSplit = "vertical"

        -- setting absolute path prevents UltiSnips from scanning my whole <runtimepath> for the <schnipsel> directory
        -- "UltiSnips" needed when using vim-snippets plugins via plugin manager
        vim.g.UltiSnipsSnippetDirectories = {
            vim.fn.expand('~/dotfiles/nvim/schnipsel/'),
            vim.fn.expand('~/dotfiles/nvim/lua/localplugins/vim-snippets/UltiSnips/')
        }

        -- Keymaps
        -- ───────
        vim.keymap.set('n', '<Leader>u', '<Cmd>call UltiSnips#RefreshSnippets()<CR>',
            { desc = 'Refresh [u]ltisnips snippets' })
    end,
}
