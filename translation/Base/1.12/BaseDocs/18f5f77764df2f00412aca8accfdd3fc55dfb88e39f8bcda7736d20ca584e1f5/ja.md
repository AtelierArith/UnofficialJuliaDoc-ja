```julia
AssertionError([msg])
```

主張された条件が `true` に評価されませんでした。オプションの引数 `msg` は、説明的なエラーストリングです。

# 例

```jldoctest
julia> @assert false "this is not true"
ERROR: AssertionError: this is not true
```

`AssertionError` は通常 [`@assert`](@ref) からスローされます。
