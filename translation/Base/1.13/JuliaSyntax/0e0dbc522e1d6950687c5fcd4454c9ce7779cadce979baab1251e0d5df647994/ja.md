```julia
SyntaxHead(kind, flags)
```

`SyntaxHead`は、構文構造の[`Kind`](@ref)とフラグの集合を組み合わせたものです。kindは構文構造の大まかな「型」を定義し、フラグビットはその構造に関するより詳細な情報をコンパクトに格納します。
