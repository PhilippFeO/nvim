local create_diary_entry = {
  name = 'Tagebuch: Erstelle Eintrag für heutigen Tag',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/.tagebuch/tagebuch/__main__.py',
  -- Application uses `input(…)`
  console = 'internalTerminal',
  cwd = vim.fn.expand '~/.tagebuch/',
  args = { '--today' },
}

local open_diary_entry = {
  name = 'Tagebuch: Öffne Eintrag für übergebenes Datum',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/.tagebuch/tagebuch/__main__.py',
  cwd = vim.fn.expand '~/.tagebuch/',
  args = { '--open', os.date('%Y-%m-%d') },
}

local past_entries = {
  name = 'Tagebuch: Öffne vergangene Einträge',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/.tagebuch/tagebuch/__main__.py',
  -- program = 'tagebuch',
  cwd = vim.fn.expand '~/.tagebuch/',
  args = { '--past', '2025-10-03' },
  -- env = {
  --   PYTHONPATH = "/home/philipp/.tagebuch/.venv/tagebuch/bin/python3",
  -- }
}

return {
  configs = {
    create_diary_entry,
    open_diary_entry,
    past_entries,
  },
}
