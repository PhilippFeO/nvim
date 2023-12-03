  -- fuzzy finder algorithm which requires local dependencies to be built.
  -- only load if `make` is available. make sure you have the system
  -- requirements installed.
return {
  'nvim-telescope/telescope-fzf-native.nvim',
  -- note: if you are having trouble with this installation,
  --       refer to the readme for telescope-fzf-native for more instructions.
  build = 'make',
  cond = function()
    return vim.fn.executable 'make' == 1
  end,
}
