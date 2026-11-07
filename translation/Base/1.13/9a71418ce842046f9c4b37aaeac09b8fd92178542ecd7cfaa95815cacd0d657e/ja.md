```julia
open_flags(; keywords...)::NamedTuple
```

指定したキーワード引数の集合に対する [`open`](@ref) a [`NamedTuple`](@ref) の `read`、`write`、`create`、`truncate`、`append` フラグ値を計算します。
