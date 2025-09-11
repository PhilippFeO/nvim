-- Work configs
-- ────────────

local treesitter = {
  name = "Tree-Sitter Callgraph",
  program = vim.fn.expand '~/python/tree-sitter-callgraph/tscg/main.py',
  request = "launch",
  type = "debugpy",
  cwd = vim.fn.expand '~/python/tree-sitter-callgraph/',
  args = {
    './tscg/source_code.py'
  },
  -- justMyCode = false,
}

local treesitter_mc = {
  name = "Tree-Sitter Callgraph – Module Code",
  program = vim.fn.expand '~/python/tree-sitter-callgraph/tscg/main.py',
  request = "launch",
  type = "debugpy",
  cwd = vim.fn.expand '~/python/tree-sitter-callgraph/',
  args = {
    './tscg/source_code.py'
  },
  justMyCode = false,
}

local treesitter_pytest = {
  name = 'Treesitter Callgraph: Unittests',
  type = 'debugpy',
  request = 'launch',
  module = 'pytest',
  cwd = DLR_Machine and vim.fn.expand '~/python/tree-sitter-callgraph/',
  args = {
    vim.fn.getcwd(),
    '-c',
    vim.fn.getcwd() .. '/test/pytest.ini',
  },
  justMyCode = true,
  redirectOutput = true,
  env = {
    PYTHONPATH = vim.fn.getcwd(),
  }
}

return {
  treesitter_pytest,
  treesitter,
  treesitter_mc,
}
