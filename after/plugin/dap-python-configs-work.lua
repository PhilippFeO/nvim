-- Work configs
-- ────────────
local TDS_creation = {
  name = 'Create TDS',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/proj/l2op/formatter_tools/createTDS.py',
  args = { '--config_file', 'cfg/debug_config_0.13.ini' }
}

local l1formatter_tds012 = {
  name = 'L1-Formatter TDS 0.12',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/proj/l2op/formatter_tools/L1b_formatter/tool_src/GeneratorL1b.py',
  cwd = vim.fn.expand '~/proj/l2op/formatter_tools/L1b_formatter/tool_src',
  args = {
    '-i',
    './TDS_0.12/01/lv1__ECA2____01_20030624_SN__0.12.nc',
    './TDS_0.12/02/lv1__ECA2____02_20030624_SN__0.12.nc',
    './TDS_0.12/03/lv1__ECA2____03_20030624_SN__0.12.nc',
    -- './TDS_0.12/04/lv1__ECA2____04_20030624_SN__0.12.nc',
    -- './TDS_0.12/05/lv1__ECA2____05_20030624_SN__0.12.nc',
    -- './TDS_0.12/06/lv1__ECA2____06_20030624_SN__0.12.nc',
    -- './TDS_0.12/07/lv1__ECA2____07_20030624_SN__0.12.nc',
    -- './TDS_0.12/08/lv1__ECA2____08_20030624_SN__0.12.nc',
    -- './TDS_0.12/09/lv1__ECA2____09_20030624_SN__0.12.nc',
    -- './TDS_0.12/10/lv1__ECA2____10_20030624_SN__0.12.nc',
    -- './TDS_0.12/11/lv1__ECA2____11_20030624_SN__0.12.nc',
    -- './TDS_0.12/12/lv1__ECA2____12_20030624_SN__0.12.nc',
    -- './TDS_0.12/13/lv1__ECA2____13_20030624_SN__0.12.nc',
    -- './TDS_0.12/14/lv1__ECA2____14_20030624_SN__0.12.nc',
    -- './TDS_0.12/15/lv1__ECA2____15_20030624_SN__0.12.nc',
    -- './TDS_0.12/16/lv1__ECA2____16_20030624_SN__0.12.nc',
    -- './TDS_0.12/17/lv1__ECA2____17_20030624_SN__0.12.nc',
    '-t', '4',
    '-o', 'output/',
  },
}

local l1formatter_tds013 = {
  -- a to have it in front of the other L1-Formatter config
  name = 'L1-Formatter TDS 0.13',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/proj/l2op/formatter_tools/L1b_formatter/tool_src/GeneratorL1b.py',
  cwd = vim.fn.expand '~/proj/l2op/formatter_tools/L1b_formatter/tool_src',
  args = {
    '-i',
    './TDS_0.13/data/detector_orientation_from_South_to_North/clearsky_fullycloudy/01/lv1__ECA2____01_20030620_SN__0.13.nc',
    -- './TDS_0.13/data/detector_orientation_from_South_to_North/clearsky_fullycloudy/02/lv1__ECA2____02_20030620_SN__0.13.nc',
    -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____04_20030620_SN__0.13.nc',
    -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____05_20030620_SN__0.13.nc',
    -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____06_20030620_SN__0.13.nc',
    -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____07_20030620_SN__0.13.nc',
    -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____08_20030620_SN__0.13.nc',
    -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____09_20030620_SN__0.13.nc',
    -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____10_20030620_SN__0.13.nc',
    -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____11_20030620_SN__0.13.nc',
    -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____12_20030620_SN__0.13.nc',
    -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____13_20030620_SN__0.13.nc',
    -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____14_20030620_SN__0.13.nc',
    -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____15_20030620_SN__0.13.nc',
    -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____16_20030620_SN__0.13.nc',
    -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____17_20030620_SN__0.13.nc',
    '-t', '4',
    '-o', 'output/',
  },
}

local ECA_tds013 = {
  name = 'ECA-Formatter TDS 0.13',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/proj/l2op/formatter_tools/ECA_formatter/tool_src/GeneratorECA.py',
  cwd = vim.fn.expand '~/proj/l2op/formatter_tools/ECA_formatter/tool_src',
  args = {
    '-l',
    'TDS_0.13/data/detector_orientation_from_South_to_North/clearsky_fullycloudy/03/lv1__ECA2____03_20030624_SN__0.13.nc',
    '-i',
    'TDS_0.13/data/detector_orientation_from_South_to_North/clearsky_fullycloudy/03/inp__ECA2____03_20030624_SN__0.13.nc',
    '-t',
    '7',
    '-o',
    'output/',
    '--unofficial_product'
  }
}

local ECA_processor = {
  name = 'ECA Prozessor',
  request = 'launch',
  type = 'python',
  program = vim.fn.expand '~/proj/ECA/jof-generator/JOFileGenerator.py',
  args = {
    '--config_file',
    'cfg/ECA_config.ini'
  },
  cwd = vim.fn.expand '~/proj/ECA/jof-generator/',
}

return {
  ECA_processor,
  ECA_tds013,
  TDS_creation,
  l1formatter_tds012,
  l1formatter_tds013,
}
