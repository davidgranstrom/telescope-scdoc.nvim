local pickers = require'telescope.pickers'
local finders = require'telescope.finders'
local conf = require'telescope.config'.values
local actions = require'telescope.actions'
local action_state = require'telescope.actions.state'
local previewers = require'telescope.previewers'
local ts_utils = require'telescope.utils'
local defaulter = ts_utils.make_default_callable

local uv = vim.loop
local api = vim.api
local scnvim = require'scnvim'
local help = require'scnvim.help'
local path_sep = require'scnvim.utils'.path_sep

local M = {}
local doc_map = nil

local function generate(callback)
  scnvim.eval('SCDoc.helpTargetDir', function(dir)
    local path = dir .. path_sep .. 'docmap.json'
    local ok, docmap = pcall(help.get_docmap, path)
    if not ok then
      error(docmap)
    end
    local entries = {}
    for k, v in pairs(docmap) do
      entries[#entries + 1] = v
    end
    table.sort(entries, function(a, b)
      return a.path:lower() < b.path:lower()
    end)
    callback(entries)
  end)
end

local function get_entries(callback)
  if doc_map then
    callback(doc_map)
  else
    generate(callback)
  end
end

local function format_entry(entry)
  local lines = {}
  table.insert(lines, '# ' .. entry.title)
  table.insert(lines, '')
  table.insert(lines, entry.summary)
  table.insert(lines, '')
  table.insert(lines, 'categories: ')
  if entry.categories then
    local categories = vim.split(entry.categories, ',', {trimempty = true})
    for _, s in ipairs(categories) do
      s = vim.trim(s)
      table.insert(lines, '  - ' .. s)
    end
  end
  table.insert(lines, 'superclasses:')
  if entry.superclasses then
    for _, s in ipairs(entry.superclasses) do
      table.insert(lines, '  - ' .. s)
    end
  end
  local related = 'related:'
  if entry.related then
    for _, s in ipairs(entry.related) do
      table.insert(lines, '  - ' .. s)
    end
  end
  table.insert(lines, 'installed: ' .. entry.installed)
  return lines
end

local summary = defaulter(function(opts)
  return previewers.new_buffer_previewer{
    title = 'summary',
    define_preview = function(self, entry)
      local bufnr = self.state.bufnr
      if self.state.bufname ~= entry.value.title then
        require'telescope.previewers.utils'.highlighter(bufnr, 'markdown')
        api.nvim_win_set_option(self.state.winid, 'wrap', true)
        api.nvim_buf_set_lines(bufnr, 0, 0, true, format_entry(entry.value))
      end
    end,
    get_buffer_by_name = function(_, entry)
      return entry.value.title
    end,
  }
end)

M.list = function(opts)
  opts = opts or {}
  get_entries(function(entries)
    -- cache the entries
    doc_map = entries
    pickers.new(opts, {
      prompt_title = 'scdoc',
      finder = finders.new_table{
        results = entries,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.title,
            ordinal = entry.title,
          }
        end
      },
      sorter = conf.file_sorter(opts),
      previewer = summary.new(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.fn['scnvim#help#open_help_for'](selection.value.title)
        end)
        return true
      end,
    }):find()
  end)
end

return M
