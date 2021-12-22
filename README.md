# telescope-scdoc.nvim

A SuperCollider documentation picker.

![telescope-scdoc.nvim](https://user-images.githubusercontent.com/672917/147115784-a39df09f-d4a0-4f89-900d-12c71cff0db2.png)

## Requirements

* scnvim
* telescope

## Installation

Install the plugin

```lua
use { 'davidgranstrom/telescope-scdoc.nvim' }
```

Load the extension *after* the call to `telescope.setup{}`

```lua
require'telescope'.load_extension('scdoc')
```

## Usage

**Note** scnvim needs to be started (`:SCNvimStart`) before you can browse the documentation.

Use the Telescope command.

```vim
:Telescope scdoc
```

Or call the function.

```vim
:lua require'telescope'.extensions.scdoc.scdoc()
```

## License

Same as Telescope.

```text
MIT License

Copyright (c) 2021 David Granström

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
