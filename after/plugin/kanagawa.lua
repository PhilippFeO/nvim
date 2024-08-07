-- :h kanagawa very useful, all written here has it's roots there

-- See end of file for additional configuration regarding LSP windows

-- Theme necessary to load colors
--  wave_colors.palette = all defined colors
--  wave_colors.theme = their usecase
--      didn't work without specifying the theme
local wave_colors = require('kanagawa.colors').setup({ theme = 'wave' })

require('kanagawa').setup({
    colors = {
        theme = {
            all = {
                ui = {
                    -- no background for signs in signcolumn
                    bg_gutter = 'none',
                    -- The original waveBlue1 is moderately visible
                    -- winterYellow also possible
                    bg_visual = wave_colors.palette.winterYellow
                }
            }
        }
    },
    -- 'overrides' is for highlight groups
    overrides = function(colors)
        local theme = colors.theme
        return {
            -- Example syntax for Treesitter related highlight groups
            -- ['@text.diff.add'] = { fg = "blue" },

            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },

            -- -- Used by vim.lsp.buf.document_highlight() on CursorHold events
            -- -- TODO: Maybe some inter highlight group linking is possible to save some code and maintenance <19-12-2023>
            -- LspReferenceText = { bg = colors.palette.dragonBlack6, bold = true },
            -- LspReferenceRead = { bg = colors.palette.dragonBlack6, bold = true },
            -- -- is also underlined
            -- LspReferenceWrite = { bg = colors.palette.dragonBlack6, bold = true },

            -- Settings for floating windows
            -- `NormalFloat` is used for LSP-Documentation (the window displaying the part behind `documentation` of a `nvim-cmp` source)
            -- The default/recommened value `"none"` is the same as in a normal buffer => It blends into main window which makes it hard to distinguish between LSP-Documentation and Code. I've set it to the same value as the Pmenu displaying all results.
            -- IDEA: background of {Lazy, Mason}Normal also possible
            NormalFloat = { bg = theme.ui.bg_p2 },
            FloatBorder = { bg = theme.ui.bg_p2 },
            FloatTitle = { bg = "none" },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

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

vim.cmd.colorscheme('kanagawa')

--[[
Borders on LSP floating windows
1. Use following function, fi. in after/plugin/mason.lua
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        -- Use a sharp border with `FloatBorder` highlights
        border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }, -- chars from kanagawa.nvim
        -- add the title in hover float window
        -- title = "hover"
      }
    )
2. Customize via fg and bg attributes of NormalFloat and FloatBorder in 'overrides' section of above setup process
    NormalFloat = { bg = "#54546D" }, -- #54546D=sumiInk4 from kanagawa
    FloatBorder = { bg = "#54546D", fg = "#cc3300" },
--]]
