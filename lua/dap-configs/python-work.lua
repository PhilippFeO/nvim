-- Work configs
-- ────────────

local arcpy_test = {
  name = "Arcpy",
  type = "python",
  request = "launch",
  program = vim.fn.expand('~/proj/e.on-mining/test.py'),
  python = vim.fn.expand('~/proj/e.on-mining/.venv/python.exe'),
}

local default_internal_console_windows = {
  console = 'internalConsole',
  name = "Debug with internalConsole [Windows]",
  program = "${file}",
  request = "launch",
  type = "python",
  -- python = vim.fn.expand('~/proj/gi-nk/.venv/gi-nk/Scripts/pythonw.exe'),
  python = vim.fn.expand('pythonw.exe'),
}

local askdante_timetracking = {
  name = 'Erstelle einen AskDante-Zeiteintrag',
  request = 'launch',
  type = 'python',
  console = 'internalConsole',
  program = 'api.py',
  args = {
    'erstelle',
    '--jira-issue-id',
    'GINK-33',
    '44',
    '2026-06-14',
    '12:00',
    '13:00',
    'projectItemId',
    '860',
    '21',
    'Dieser Eintrag ist im Debugger entstanden.',
  },
}

-- ────────────────────────────────────────

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
  cwd = IS_WORK_MACHINE and vim.fn.expand '~/python/tree-sitter-callgraph/',
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
  configs = {
    arcpy_test,
    default_internal_console_windows,
    askdante_timetracking,
    treesitter_pytest,
    treesitter,
    treesitter_mc,
  }
}
