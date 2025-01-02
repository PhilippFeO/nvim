-- https://www.youtube.com/watch?v=5PIiKDES_wc&themeRefresh=1
-- https://github.com/tjdevries/advent-of-nvim/blob/master/nvim/plugin/floaterminal.lua

-- default; no floating terminal was initialized
local state = {
    floating = {
        buf = -1,
        win = -1,
    }
}

-- opts will hold the buf number only
local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)

    -- Calculate the position to center the window
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    -- Does the specified buffer already exists?
    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
        -- if not, create one
    else
        buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
    end

    -- Define window configuration
    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal", -- No borders or extra UI elements
        -- `h hl-FloatBorder`
        -- `:Telescope highlights` reveals `FloatermBorder` hl group
        border = "solid",
    }

    -- Create the floating window based on the created buffer
    local win = vim.api.nvim_open_win(buf, true, win_config)

    return { buf = buf, win = win }
end

local toggle_terminal = function()
    -- No floating window/terminal was established
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        -- Create floating window
        state.floating = create_floating_window { buf = state.floating.buf }
        -- Make it a terminal
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
        end
        vim.cmd.startinsert()
    else
        -- If floating terminal already exists, hide it
        vim.api.nvim_win_hide(state.floating.win)
    end
end

vim.keymap.set({ "n", "t" }, "<Leader>tt", toggle_terminal, { desc = '[t]oggle [t]erminal' })
vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-n>", { desc = 'Enter Normal mode within terminal' })
