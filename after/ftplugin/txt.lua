vim.keymap.set({ 'n', 'v' }, 'j', 'gj',
    {
        desc = 'Make <j> act as <gj>, ie. "visual line j"',
        -- Only for the buffer. It should really really only apply to tex files
        buffer = true,
    })
vim.keymap.set({ 'n', 'v' }, 'k', 'gk',
    {
        desc = 'Make <j> act as <gj>, ie. "visual line j"',
        -- Only for the buffer. It should really really only apply to tex files
        buffer = true,
    })
