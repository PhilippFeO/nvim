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

local chronograph_erstelle = {
  name = 'chronograph erstelle …',
  request = 'launch',
  type = 'python',
  console = 'integratedTerminal',
  -- Start as module => relative imports work
  module = 'chronograph.main',
  cwd = '${workspaceFolder}',
  args = {
    'erstelle',
    '--jira-issue-id',
    'GINK-33',
    '2026-06-14',
    '12:00',
    '13:00',
    'projectItemId',
    '860',
    '21',
    'Dieser Eintrag ist im Debugger entstanden.',
  },
}

local chronograph_csv = {
  name = 'chronograph csv 651 155 2026-05-01 2026-05-31',
  request = 'launch',
  type = 'python',
  console = 'integratedTerminal',
  -- Start as module => relative imports work
  module = 'chronograph.main',
  cwd = '${workspaceFolder}',
  args = {
    'csv',
    '651',
    '155',
    '2026-05-01',
    '2026-05-31',
  },
}

local chronograph_nutzer_projekte = {
  name = 'chronograph --nutzer-projekte',
  request = 'launch',
  type = 'python',
  console = 'integratedTerminal',
  -- Start as module => relative imports work
  module = 'chronograph.main',
  cwd = '${workspaceFolder}',
  args = {
    '--nutzer-projekte',
  },
}

local chronograph_nutzer_teilprojekte = {
  name = 'chronograph --nutzer-teilprojekte',
  request = 'launch',
  type = 'python',
  console = 'integratedTerminal',
  -- Start as module => relative imports work
  module = 'chronograph.main',
  cwd = '${workspaceFolder}',
  args = {
    '--nutzer-teilprojekte',
  },
}
local garage = {
  name = 'Garage',
  type = 'python',
  request = 'launch',
  program = '${workspaceFolder}/manage.py',
  django = true,
  args = {
    'runserver'
  },
  env = {
    EMAIL_HOST_USER = 'lorem@ipsum.de',
    SECRET_KEY = 'django-insecure-ivvcj*%d@qhm1&#e&rez)ot35prmz$d@-bg6mbpd*m*i281ax)',
    DEBUG = 'true',
  },
}

local garage_justMyCode_false = {
  name = 'Garage + justMyCode = false',
  type = 'python',
  request = 'launch',
  program = '${workspaceFolder}/manage.py',
  django = true,
  args = {
    'runserver'
  },
  -- env = {
  --   EMAIL_HOST_USER = 'lorem@ipsum.de',
  --   SECRET_KEY = 'django-insecure-ivvcj*%d@qhm1&#e&rez)ot35prmz$d@-bg6mbpd*m*i281ax)',
  --   DEBUG = 'true',
  -- },
  justMyCode = false,
}

local garage_sync_user_projects_justMyCode_false = {
  name = 'Garage – sync_user_projects + justMyCode = false',
  type = 'python',
  request = 'launch',
  program = '${workspaceFolder}/manage.py',
  django = true,
  args = {
    'sync_user_projects'
  },
  -- env = {
  --   EMAIL_HOST_USER = 'lorem@ipsum.de',
  --   SECRET_KEY = 'django-insecure-ivvcj*%d@qhm1&#e&rez)ot35prmz$d@-bg6mbpd*m*i281ax)',
  --   DEBUG = 'true',
  -- },
  justMyCode = true,
}

local eon_mining = {
  name = 'E.On-Mining [Modul]',
  type = 'python',
  request = 'launch',
  module = 'source.migration_grubenfeld.stammbaum',
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
    chronograph_erstelle,
    chronograph_csv,
    chronograph_nutzer_projekte,
    chronograph_nutzer_teilprojekte,
    garage,
    garage_justMyCode_false,
    garage_sync_user_projects_justMyCode_false,
    eon_mining,
    treesitter_pytest,
    treesitter,
    treesitter_mc,
  }
}
