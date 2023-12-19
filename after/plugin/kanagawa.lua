require('kanagawa').setup({
    colors = {
        theme = {
            all = {
                ui = {
                    -- no background for signs in signcolumn
                    bg_gutter = 'none'
                }
            }
        }
    },
    -- overrides = function(colors)
    --     return {
    --         ['@text.diff.add'] = { fg = "blue" },
    --     }
    -- end
    overrides = function(colors)
        local theme = colors.theme
        return {
            -- Settings for floating windows
            NormalFloat = { bg = "none" }, -- try #54546D=sumiInk4 from kanagawa
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            --[[
                Borders on LSP floating windows
                1. Use following function, fi. in mason.lua
                    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
                      vim.lsp.handlers.hover, {
                        -- Use a sharp border with `FloatBorder` highlights
                        border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }, -- chars from kanagawa.nvim
                        -- add the title in hover float window
                        -- title = "hover"
                      }
                    )
                2. Customize via fg and bg attributes of NormalFloat and FloatBorder, f.i.
                    NormalFloat = { bg = "#54546D" }, -- sumiInk4 from kanagawa
                    FloatBorder = { bg = "#54546D", fg = "#cc3300" },
            --]]

            -- Settings for telescope (borderless)
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
            TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
        }
    end,
})

vim.cmd.colorscheme 'kanagawa'
