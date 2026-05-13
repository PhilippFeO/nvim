IS_WORK_MACHINE = true
ON_WINDOWS = vim.fn.has('win32')

if IS_WORK_MACHINE and ON_WINDOWS then
    vim.cmd([[
        " `h shell-powershell`
        " Using these two commands from the Help doesnt work, so I replaced them.
		"let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
		"let &shellcmdflag = '-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';$PSStyle.OutputRendering=''plaintext'';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
		let &shell = 'powershell.exe'
		let &shellcmdflag = '-Command'
		let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
		let &shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
		set shellquote= shellxquote=
    ]])

    -- According to https://blog.nikfp.com/how-to-install-and-set-up-neovim-on-windows this might accelerate Neovim on Windows (for me, it doesn't):
    vim.g.nofsync = true
end
