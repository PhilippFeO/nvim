local create_diary_entry = {
  name = 'Tagebuch: Erstelle Eintrag für heutigen Tag',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/.tagebuch/tagebuch/__main__.py',
  args = { '--today' },
  cwd = vim.fn.expand '~/.tagebuch/',
}

local open_diary_entry = {
  name = 'Tagebuch: Öffne Eintrag für übergebenes Datum',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/.tagebuch/tagebuch/__main__.py',
  args = { '--open', os.date('%Y-%m-%d') },
  cwd = vim.fn.expand '~/.tagebuch/',
}

local past_entries = {
  name = 'Tagebuch: Öffne vergangene Einträge',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/.tagebuch/tagebuch/__main__.py',
  -- program = 'tagebuch',
  args = { '--past', '2025-06-09' },
  cwd = vim.fn.expand '~/.tagebuch/',
  -- env = {
  --   PYTHONPATH = "/home/philipp/.tagebuch/.venv/tagebuch/bin/python3",
  -- }
}

local add_fotos = {
  name = 'Tagebuch: Füge Fotos zu Tagebuch hinzu',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/.tagebuch/tagebuch/add_fotos.py',
  args = { vim.fn.expand '~/Bilder/z_tmp/test_tagebuch/', },
  cwd = vim.fn.expand '~/.tagebuch/',
}

local create_db = {
  name = 'Tagebuch: Erstelle DB',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/.tagebuch/tagebuch/create_db.py',
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
  args = { '-rA', '-sv', './tests/test_create_db.py', './tests/test_helper.py', './tests/test_new_entry.py', './tests/test_render_diary_template.py', },
  -- program = vim.fn.expand '~/.tagebuch/tests/test_create_db.py',
}

return {
  configs = {
    create_diary_entry,
    open_diary_entry,
    past_entries,
    add_fotos,
    create_db,
    test_create_db,
    tests,
  },
  -- Necessary as key-value-pair for keymap for test_method (2025-09-12: <Leader>dm)
  test_configs = {
    test_create_db,
    tests,
  }
}
