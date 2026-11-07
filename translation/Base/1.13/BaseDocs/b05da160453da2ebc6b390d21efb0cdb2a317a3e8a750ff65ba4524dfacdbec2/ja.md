```julia
AssertionError([msg])
```

アサートされた条件の評価結果が `true` ではありませんでした。省略可能な引数 `msg` は、エラーを説明する文字列です。

# Examples

```jldoctest
julia> @assert false "this is not true"
ERROR: AssertionError: this is not true
```

`AssertionError` は通常、[`@assert`](@ref) からスローされます。
