```
define_editor(fn, pattern; wait=false)
```

Define a new editor matching `pattern` that can be used to open a file (possibly at a given line number) using `fn`.

The `fn` argument is a function that determines how to open a file with the given editor. It should take four arguments, as follows:

  * `cmd` - a base command object for the editor
  * `path` - the path to the source file to open
  * `line` - the line number to open the editor at
  * `column` - the column number to open the editor at

Editors which cannot open to a specific line with a command or a specific column may ignore the `line` and/or `column` argument. The `fn` callback must return either an appropriate `Cmd` object to open a file or `nothing` to indicate that they cannot edit this file. Use `nothing` to indicate that this editor is not appropriate for the current environment and another editor should be attempted. It is possible to add more general editing hooks that need not spawn external commands by pushing a callback directly to the vector `EDITOR_CALLBACKS`.

The `pattern` argument is a string, regular expression, or an array of strings and regular expressions. For the `fn` to be called, one of the patterns must match the value of `EDITOR`, `VISUAL` or `JULIA_EDITOR`. For strings, the string must equal the [`basename`](@ref) of the first word of the editor command, with its extension, if any, removed. E.g. "vi" doesn't match "vim -g" but matches "/usr/bin/vi -m"; it also matches `vi.exe`. If `pattern` is a regex it is matched against all of the editor command as a shell-escaped string. An array pattern matches if any of its items match. If multiple editors match, the one added most recently is used.

By default julia does not wait for the editor to close, running it in the background. However, if the editor is terminal based, you will probably want to set `wait=true` and julia will wait for the editor to close before resuming.

If one of the editor environment variables is set, but no editor entry matches it, the default editor entry is invoked:

```
(cmd, path, line, column) -> `$cmd $path`
```

Note that many editors are already defined. All of the following commands should already work:

  * emacs
  * emacsclient
  * vim
  * nvim
  * nano
  * micro
  * kak
  * helix
  * textmate
  * mate
  * kate
  * subl
  * atom
  * notepad++
  * Visual Studio Code
  * open
  * pycharm
  * bbedit

# Examples

The following defines the usage of terminal-based `emacs`:

```
define_editor(
    r"\bemacs\b.*\s(-nw|--no-window-system)\b", wait=true) do cmd, path, line
    `$cmd +$line $path`
end
```

!!! compat "Julia 1.4"
    `define_editor` was introduced in Julia 1.4.

