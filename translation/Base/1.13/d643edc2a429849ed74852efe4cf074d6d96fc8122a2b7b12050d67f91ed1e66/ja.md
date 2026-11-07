```julia
maximum(itr; [init])
```

コレクション内の最大の要素を返します。

空の `itr` に対して返す値は、`init` で指定できます。空でないコレクションで `init` が使用されるかどうかは定められていないため、この値は `max` の中立元（つまり、ほかのどの要素以下でもある値）でなければなりません。

!!! compat "Julia 1.6"
    キーワード引数 `init` を使用するには、Julia 1.6 以降が必要です。


# Examples

```jldoctest
julia> maximum(-20.5:10)
9.5

julia> maximum([1,2,3])
3

julia> maximum(())
ERROR: ArgumentError: reducing over an empty collection is not allowed; consider supplying `init` to the reducer
Stacktrace:
[...]

julia> maximum((); init=-Inf)
-Inf
```
