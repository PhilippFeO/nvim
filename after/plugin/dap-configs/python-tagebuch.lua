local render_diary_template = {
  name = 'Tagebuch: Erstelle und öffne Eintrag',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/.tagebuch/tagebuch/render_diary_template.py',
  cwd = vim.fn.expand '~/.tagebuch/',
  args = { vim.fn.expand '~/.tagebuch/2025/10-Oktober/2025-10-03/' },
}

return {
  configs = {
    render_diary_template,
  },
}
