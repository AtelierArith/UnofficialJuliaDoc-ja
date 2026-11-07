```julia
peek(stream::ParseStream [, n=1]; skip_newlines=false)
```

Look ahead in the stream `n` tokens, returning the token kind. Comments and non-newline whitespace are skipped automatically. Whitespace containing a single newline is returned as kind `K"NewlineWs"` unless `skip_newlines` is true.
