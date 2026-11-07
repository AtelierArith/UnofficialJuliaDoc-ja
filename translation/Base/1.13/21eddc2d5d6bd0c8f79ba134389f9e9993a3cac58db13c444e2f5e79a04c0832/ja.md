```julia
minimum(f, itr; [init])
```

`itr` の各要素に関数 `f` を適用した結果のうち、最小の値を返します。

空の `itr` に対して返す値は、`init` で指定できます。この値は `min` の中立元（つまり、他のどの要素以上でもある値）でなければなりません。空でないコレクションでは `init` が使われるかどうかが未指定だからです。

!!! compat "Julia 1.6"
    キーワード引数 `init` を使用するには、Julia 1.6 以降が必要です。


# Examples

```jldoctest
julia> minimum(length, ["Julion", "Julia", "Jule"])
4

julia> minimum(length, []; init=typemax(Int64))
9223372036854775807

julia> minimum(sin, Real[]; init=1.0)  # good, since output of sin is <= 1
1.0
```
