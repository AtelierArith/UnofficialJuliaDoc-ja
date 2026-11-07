```julia
bump(stream [, flags=EMPTY_FLAGS];
     skip_newlines=false, error, remap_kind)
```

Copy the current token from the input stream to the output. Adds the given flags to the output token (normally this would be the default `EMPTY_FLAGS` or `TRIVIA_FLAG`).

Keyword arguments:

  * `skip_newlines` - if `true`, newlines are treated as whitespace.
  * `error` - if set, emit an error for this token
  * `remap_kind` - the kind of the token in the output token stream if it needs                to be modified.
