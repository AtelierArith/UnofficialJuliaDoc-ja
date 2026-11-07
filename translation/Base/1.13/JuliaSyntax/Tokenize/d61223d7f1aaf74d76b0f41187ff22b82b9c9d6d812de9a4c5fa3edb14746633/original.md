```julia
accept(l::Lexer, f::Union{Function, Char, Vector{Char}, String})
```

Consumes the next character `c` if either `f::Function(c)` returns true, `c == f` for `c::Char` or `c in f` otherwise. Returns `true` if a character has been consumed and `false` otherwise.
