local open_diary_entry = {
  name = 'Tagebuch: Erstelle und öffne Eintrag',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/.tagebuch/tagebuch/open_diary_entry.py',
  cwd = vim.fn.expand '~/.tagebuch/',
  args = { vim.fn.expand '~/.tagebuch/2025/10-Oktober/2025-10-03/' },
}

local past_entries = {
  name = 'Tagebuch: Öffne vergangene Einträge',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/.tagebuch/tagebuch/__main__.py',
  -- program = 'tagebuch',
  cwd = vim.fn.expand '~/.tagebuch',
  args = { '--past', '2025-10-03' },
  -- env = {
  --   PYTHONPATH = "/home/philipp/.tagebuch/.venv/tagebuch/bin/python3",
  -- }
}

return {
  configs = {
    open_diary_entry,
    past_entries,
  },
}
