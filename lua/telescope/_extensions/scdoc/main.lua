local pickers = require'telescope.pickers'
local finders = require'telescope.finders'
local conf = require'telescope.config'.values
local actions = require'telescope.actions'
local action_state = require'telescope.actions.state'

local uv = vim.loop
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
          local max_len = 24
          local path = entry.title:sub(1, max_len)
          if #path < max_len then
            path = path .. string.rep(' ', max_len - #path)
          end
          return {
            value = entry,
            display = string.format('%s | %s', path, entry.summary),
            ordinal = entry.title,
          }
        end
      },
      sorter = conf.file_sorter(opts),
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
