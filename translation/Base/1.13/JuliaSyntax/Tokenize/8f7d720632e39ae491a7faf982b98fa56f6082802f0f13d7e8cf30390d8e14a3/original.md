```julia
emit(l::Lexer, kind::Kind)
```

Returns a `RawToken` of kind `kind` with contents `str` and starts a new `RawToken`.
