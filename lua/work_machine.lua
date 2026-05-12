IS_WORK_MACHINE = true
ON_WINDOWS = vim.fn.has('win32')

if IS_WORK_MACHINE and ON_WINDOWS then
    vim.opt.shell = 'cmd.exe'
    -- According to https://blog.nikfp.com/how-to-install-and-set-up-neovim-on-windows this might accelerate Neovim on Windows (for me, it doesn't):
    vim.g.nofsync = true
end
