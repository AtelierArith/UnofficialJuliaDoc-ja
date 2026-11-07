```julia
accept(l::Lexer, f::Union{Function, Char, Vector{Char}, String})
```

`f::Function(c)` が true を返す場合は次の文字 `c` を消費し、そうでない場合は `c == f` を `c::Char` または `c in f` に対して消費します。文字を消費した場合は `true` を返し、そうでない場合は `false` を返します。
