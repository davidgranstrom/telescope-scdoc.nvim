# Telescope scdoc

A SuperCollider documentation picker.

## Requirements

* scnvim
* telescope

## Installation

Install the plugin with your package manager

* packer.nvim
```lua
use { 'davidgranstrom/telescope-scdoc' }
```

Load the extension *after* the call to `telescope.setup{}`

```lua
require'telescope'.load_extension('scdoc')
```

## Usage

Note that `scnvim` needs to be started before you can browse the documentation.

Select the picker using the `Telescope` command

```viml
:Telescope scdoc
```

Call the picker from lua
```lua
:lua require'telescope'.extensions.scdoc.scdoc()
```

## License
