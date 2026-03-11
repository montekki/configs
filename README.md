# My Configuration Files

There are the configuration files that I use for my default development environment
both on Linux and MacOS.

Here is the list of tools I am using:

* [neovim](https://github.com/neovim/neovim) as the editor
* [alacritty](https://github.com/alacritty/alacritty) as the terminal emulator
* [starship](https://github.com/starship/starship) shell prompt
* [tmux](https://github.com/tmux/tmux) multiplexer to multiplex stuff within the terminal
* [fish](https://github.com/fish-shell/fish-shell) as a shell

### Neovim dependencies

* [lua-language-server](https://github.com/LuaLS/lua-language-server) LSP server for Lua
* [rust-analyzer](https://github.com/rust-lang/rust-analyzer) LSP server for Rust
* [jsonnet-language-server](https://github.com/grafana/jsonnet-language-server) LSP server for Jsonnet
* [stylua](https://github.com/JohnnyMorganz/StyLua) Lua code formatter
* [fd](https://github.com/sharkdp/fd) fast file finder, used by the fzf `:Files` command
* [proximity-sort](https://github.com/jonhoo/proximity-sort) sorts fzf results by proximity to the current file

### Shell / terminal dependencies

* [fzf](https://github.com/junegunn/fzf) fuzzy finder
* [bat](https://github.com/sharkdp/bat) syntax-highlighted file viewer, aliased as `cat`
* [eza](https://github.com/eza-community/eza) modern `ls` replacement, aliased as `ls`
* [wl-copy](https://github.com/bugaevc/wl-clipboard) Wayland clipboard utility (Linux)
* [xsel](https://github.com/kfish/xsel) X11 clipboard utility (Linux, used by tmux)

## Basic usage

All the tools necessary have to be installed on the target platform, be it Linux on MacOS.
Then just clone the repo somewhere and create symlinks from default paths to config files
on this platform to the files or folders in the cloned repository.

For me in the case of MacOS it would look like this:

```
~/.config/alacritty -> ~/github.com/montekki/configs/alacritty
~/.config/fish -> ~/github.com/montekki/configs/fish
~/.config/nvim -> ~/github.com/montekki/configs/nvim
~/.config/starship.toml -> ~/github.com/montekki/configs/starship/starship.toml
```

### `fzf` + `gh`

[fzf](https://github.com/junegunn/fzf) is a really cool fuzzy-finder that I use any time I have a chance to.
For example, you can write convenience wrappers for `fzf` and [`gh` github cli](https://cli.github.com/):

https://github.com/montekki/configs/blob/da49ff6267cbcd32ce0bfd3c99238b189d645a47/fish/config.fish#L41-L46
