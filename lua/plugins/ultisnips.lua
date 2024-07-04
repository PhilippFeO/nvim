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
        -- "UltiSnips" needed for vim-snippets/UltiSnips/ directory
        vim.g.UltiSnipsSnippetDirectories = { "UltiSnips", vim.fn.expand("~/dotfiles/nvim/schnipsel/") }

        -- Keymaps
        -- ───────
        vim.keymap.set('n', '<Leader>u', '<Cmd>call UltiSnips#RefreshSnippets()<CR>',
            { desc = 'Refresh [u]ltisnips snippets' })
    end,
}
