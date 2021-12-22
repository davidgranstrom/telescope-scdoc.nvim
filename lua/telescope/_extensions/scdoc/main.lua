local pickers = require'telescope.pickers'
local finders = require'telescope.finders'
local conf = require'telescope.config'.values
local actions = require'telescope.actions'
local action_state = require'telescope.actions.state'

local uv = vim.loop
local scnvim = require'scnvim'
local scnvim_utils = require'scnvim.utils'

local M = {}

local function generate(callback)
  scnvim.eval('SCDoc.helpTargetDir', function(res)
    local path = res .. scnvim_utils.path_sep .. 'docmap.json'
    local stat = uv.fs_stat(path)
    assert(stat, 'Could not find docmap.json')
    local fd = uv.fs_open(path, 'r', 0)
    local size = stat.size
    local file = uv.fs_read(fd, size, 0)
    local ok, result = pcall(vim.fn.json_decode, file)
    uv.fs_close(fd)
    if not ok then
      error(result)
    end
    local entries = {}
    for k, v in pairs(result) do
      entries[#entries + 1] = v
    end
    table.sort(entries, function(a, b)
      return a.path:lower() < b.path:lower()
    end)
    callback(entries)
  end)
end

local function get_entries(callback)
  if M.doc_map then
    callback(M.doc_map)
  else
    generate(callback)
  end
end

M.list = function(opts)
  opts = opts or {}
  get_entries(function(entries)
    M.doc_map = entries
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
