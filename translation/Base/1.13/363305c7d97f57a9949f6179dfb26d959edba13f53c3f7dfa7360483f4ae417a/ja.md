```julia
maximum(f, itr; [init])
```

`itr` の各要素に関数 `f` を適用した結果のうち、最大の値を返します。

`itr` の場合に返す値は、`init` で指定できます。この値は `max` の中立元（つまり、他のどの要素以下でもある値）でなければなりません。空でないコレクションで `init` が使われるかどうかは未指定だからです。

!!! compat "Julia 1.6"
    キーワード引数 `init` を使用するには、Julia 1.6 以降が必要です。


# Examples

```jldoctest
julia> maximum(length, ["Julion", "Julia", "Jule"])
6

julia> maximum(length, []; init=-1)
-1

julia> maximum(sin, Real[]; init=-1.0)  # good, since output of sin is >= -1
-1.0
```
