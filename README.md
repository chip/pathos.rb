# pathos.rb - CLI for editing a PATH env variable

## Background

If you're like me, you might have a number of `export PATH` statements
littering your shell resource file (e.g., `.zshrc`, `.bashrc`, etc). Over time,
many directory entries get added and revised. Those that remain eventually
become unnecessary, are mistakenly duplicated, or represent directories that no
longer exist on the system. This is my attempt at cleaning up `PATH`
environment variable. Hopefully, others will find this to be useful.

## Demo

![pathos DEMO](assets/demo.gif "pathos.rb DEMO")

### Built with the following:

  * [Ruby](https://ruby-lang.org/)
  * [TTY Tookkit](https://github.com/piotrmurach/tty)

## Installation
  1. Clone repo.
  2. Change to repo directory (*Assuming /Users/code/pathos.rb*):
    cd /Users/code/pathos.rb
  3. Run pathos.rb:
    ruby pathos.rb

## IMPORTANT

Each time you save your changes to the directory list, `pathos.rb` will build a
revised `export $PATH` statement that is written to `$HOME/.pathos.env`.

To use the new PATH, `$HOME/.pathos.env` **MUST BE SOURCED** to take effect
within your shell.

    source $HOME/pathos.env

## Navigation / Commands

Key | Description
----|---
↑/k | up
↓/j | down
o   | add path (below current selected path)*
O   | add path (above current selected path)*
x   | remove current path
X   | remove non-existent paths
D   | remove duplicate paths
S   | save
q   | quit

* *The current selected path is highlighted in Yellow*

## Color Highlighting

Color | Description
---|---
<span style="background-color:black"> &nbsp; <span style="color:yellow">Yellow</span> &nbsp; </span> | Shows current selected path</span>
<span style="background-color:black"> &nbsp; <span style="color:red">Red</span> &nbsp; </span> | Indicates paths that **do not exist**
<span style="background-color:black"> &nbsp; <span style="color:aqua">Aqua</span> &nbsp; </span> | Indicates duplicate paths
