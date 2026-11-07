```julia
open_flags(; keywords...)::NamedTuple
```

指定したキーワード引数のセットに対して、[`open`](@ref) a [`NamedTuple`](@ref) の `read`、`write`、`create`、`truncate`、`append` フラグ値を計算します。
