```julia
maximum(f, itr; [init])
```

`f` を `itr` の各要素に適用した結果の最大値を返します。

空の `itr` に対して返す値は、`init` で指定できます。`init` が空でないコレクションに対して使われるかどうかは未指定のため、この値は `max` の中立元（つまり、ほかのどの要素以下でもある値）でなければなりません。

!!! compat "Julia 1.6"
    キーワード引数 `init` を使うには、Julia 1.6 以降が必要です。


# Examples

```jldoctest
julia> maximum(length, ["Julion", "Julia", "Jule"])
6

julia> maximum(length, []; init=-1)
-1

julia> maximum(sin, Real[]; init=-1.0)  # good, since output of sin is >= -1
-1.0
```
