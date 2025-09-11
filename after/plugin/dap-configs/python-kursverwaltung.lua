-- https://code.visualstudio.com/docs/python/tutorial-django
-- https://stackoverflow.com/questions/62944425/how-to-debug-django-in-vscode-with-autoreload-turned-on
local kursverwaltung = {
  name = "Kursverwaltung",
  type = "debugpy",
  request = "launch",
  program = "${workspaceFolder}/manage.py",
  args = { "runserver", "--settings=kursverwaltung.settings_dev" },
  env = {
    EMAIL_HOST_USER = 'lorem@ipsum.de',
    SECRET_KEY = 'django-insecure-ivvcj*%d@qhm1&#e&rez)ot35prmz$d@-bg6mbpd*m*i281ax)',
    DEBUG = 'true',
  },
  django = true,
  justMyCode = true,
}

local kursverwaltung_unittest = {
  name = "Kursverwaltung – Unittest",
  type = "debugpy",
  request = "launch", -- or 'attach' TODO: What does attach? <27-01-2024>
  module = "pytest",
  -- TODO: Define args via `pytest.ini`. <27-01-2024>
  args = {
    "-rA",
    "-sv",
    './tests/',
  },
  -- justMyCode = false,
  redirectOutput = true,
  -- Display return value of function in DAP Scopes window
  showReturnValue = false,
  env = {
    EMAIL_HOST_USER = 'lorem@ipsum.de',
    SECRET_KEY = 'django-insecure-ivvcj*%d@qhm1&#e&rez)ot35prmz$d@-bg6mbpd*m*i281ax)',
    -- DEBUG = true,
  }
}


local kursverwaltung_docker_unittest = {
  name = 'Kursverwaltung – docker – Unittest',
  type = 'python',
  request = 'attach',
  connect = {
    host = 'localhost',
    port = 5678,
  },
  -- Damit Print-Ausgaben im Debugger auftauchen
  redirectOutput = true,
  justMyCode = true,
  pathMappings = {
    {
      localRoot = vim.fn.getcwd(),
      remoteRoot = '/home/developer/development/kursverwaltung',
    },
  },
  env = {
    EMAIL_HOST_USER = 'lorem@ipsum.de',
    SECRET_KEY = 'django-insecure-ivvcj*%d@qhm1&#e&rez)ot35prmz$d@-bg6mbpd*m*i281ax)',
    DEBUG = 'true',
  },
}

local kursverwaltung_docker = {
  name = 'Kursverwaltung – docker',
  type = 'python',
  request = 'attach',
  connect = {
    host = 'localhost',
    port = 5678,
  },
  -- Damit Print-Ausgaben im Debugger auftauchen
  redirectOutput = true,
  justMyCode = true,
  pathMappings = {
    -- Die Dateipfade werden relativ zu diesen Verzeichnissen aufgelöst:
    -- localRoot/kursverwaltung/views.py -> remoteRoot/kursverwaltung/views.py
    {
      -- Verzeichnis unter dem der Quellcode bei mir lokal liegt
      -- (Ich sollte in ~/programmieren/kursverwaltung/kursverwaltung/ sein)
      localRoot = vim.fn.getcwd(),
      -- Verzeichnis, unter dem der Quellcode auf dem anderen Rechner liegt
      remoteRoot = '/home/developer/development/kursverwaltung',
    },
  },
}

local kursverwaltung_docker_listen = {
  name = 'Kursverwaltung – docker – listen',
  type = 'python',
  request = 'listen',
  listen = {
    host = 'localhost',
    port = 5678,
  },
  -- Damit Print-Ausgaben im Debugger auftauchen
  redirectOutput = true,
  justMyCode = true,
  pathMappings = {
    -- Die Dateipfade werden relativ zu diesen Verzeichnissen aufgelöst:
    -- localRoot/kursverwaltung/views.py -> remoteRoot/kursverwaltung/views.py
    {
      -- Verzeichnis unter dem der Quellcode bei mir lokal liegt
      -- (Ich sollte in ~/programmieren/kursverwaltung/kursverwaltung/ sein)
      localRoot = vim.fn.getcwd(),
      -- Verzeichnis, unter dem der Quellcode auf dem anderen Rechner liegt
      remoteRoot = '/home/developer/development/kursverwaltung',
    },
  },
}


return {
  kursverwaltung,
  kursverwaltung_docker,
  kursverwaltung_docker_unittest,
  kursverwaltung_unittest,
  kursverwaltung_docker_listen,
  -- key-value-pair necessary to use in Keymap <Leader>dm in after/plugin/dap-keymaps.lua for debugging single test method
  kursverwaltung_unittest = kursverwaltung_unittest,
  kursverwaltung_docker_unittest = kursverwaltung_docker_unittest,
}
