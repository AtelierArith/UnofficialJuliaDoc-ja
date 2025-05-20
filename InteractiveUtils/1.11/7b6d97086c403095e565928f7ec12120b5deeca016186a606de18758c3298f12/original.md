```
EDITOR_CALLBACKS :: Vector{Function}
```

A vector of editor callback functions, which take as arguments `cmd`, `path`, `line` and `column` and which is then expected to either open an editor and return `true` to indicate that it has handled the request, or return `false` to decline the editing request.
