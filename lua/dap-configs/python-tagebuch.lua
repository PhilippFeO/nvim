local dap_defaults = {
  request = 'launch',
  type = 'python',
}
local name_stump = 'tagebuch'
local module_stump = 'tagebuch'

local import_jinja = vim.tbl_extend(
  'force',
  {
    name = name_stump .. ' --import-jinja',
    module = module_stump .. '.import_jinja',
    args = {
      '2026-06-07',
    }
  },
  dap_defaults
)

-- ────────────────────────────────────────

local dap_defaults_old = {
  request = 'launch',
  type = 'python',
  program = vim.fn.expand('~/.tagebuch/tagebuch/__main__.py'),
  cwd = vim.fn.expand('~/.tagebuch/'),
}

local create_diary_entry_cron = vim.tbl_extend(
  'force',
  {
    args = { '--cron' },
    name = 'tagebuch --cron',
  },
  dap_defaults_old
)

local arg = '2026-06-07'

local create_diary_entry = {
  name = 'tagebuch --today',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand('~/.tagebuch/tagebuch/__main__.py'),
  args = { '--today' },
  cwd = vim.fn.expand('~/.tagebuch/'),
}

local open_diary_entry = {
  name = string.format('tagebuch --open %s', arg),
  request = 'launch',
  type = 'python',
  program = vim.fn.expand('~/.tagebuch/tagebuch/__main__.py'),
  -- args = { '--open', os.date('%Y-%m-%d') },
  args = { '--open', arg },
  cwd = vim.fn.expand('~/.tagebuch/'),
}

arg = '2025-06-09'
local past_entries = {
  name = string.format('tagebuch --past %s', arg),
  request = 'launch',
  type = 'python',
  program = vim.fn.expand('~/.tagebuch/tagebuch/__main__.py'),
  -- program = 'tagebuch',
  args = { '--past', arg },
  cwd = vim.fn.expand('~/.tagebuch/'),
  -- env = {
  --   PYTHONPATH = "/home/philipp/.tagebuch/.venv/tagebuch/bin/python3",
  -- }
}

local past_last_month = {
  name = 'tagebuch --last-month',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand('~/.tagebuch/tagebuch/__main__.py'),
  args = { '--last-month' },
  cwd = vim.fn.expand('~/.tagebuch/'),
}

arg = vim.fn.expand('.tmp/diese_fotos_einsortieren/')
local add_fotos = {
  name = string.format('tagebuch --add-fotos %s', arg),
  request = 'launch',
  type = 'python',
  program = vim.fn.expand('tagebuch/__main__.py'),
  args = { '--add-fotos', arg },
  cwd = vim.fn.expand('~/.tagebuch/'),
}

local create_db = {
  name = 'Tagebuch: Erstelle DB',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand('~/.tagebuch/tagebuch/create_db.py'),
}

local test_create_db = {
  name = 'Tagebuch: Teste DB-Erstellung (create_db.py)',
  request = 'launch',
  type = 'python',
  module = 'pytest',
  args = { '-rA', '-sv', './tests/test_create_db.py' },
  -- program = vim.fn.expand '~/.tagebuch/tests/test_create_db.py',
}

local tests = {
  name = 'Tagebuch: Unittests',
  request = 'launch',
  type = 'python',
  module = 'pytest',
  args = {
    '-rA',
    '-sv',
    './tests/test_create_db.py',
    './tests/test_helper.py',
    './tests/test_new_entry.py',
    './tests/test_render_diary_template.py',
  },
  -- program = vim.fn.expand '~/.tagebuch/tests/test_create_db.py',
}

return {
  configs = {
    import_jinja
    -- create_diary_entry_cron,
    -- create_diary_entry,
    -- open_diary_entry,
    -- past_entries,
    -- add_fotos,
    -- create_db,
    -- test_create_db,
    -- tests,
    -- past_last_month,
  },
  -- -- Necessary as key-value-pair for keymap for test_method (2025-09-12: <Leader>dm)
  -- test_configs = {
  --   test_create_db,
  --   tests,
  -- },
}
