local main = require'telescope._extensions.scdoc.main'

return require'telescope'.register_extension{
  setup = function(conf)
  end,
  exports = {
    scdoc = main.list,
  },
}
