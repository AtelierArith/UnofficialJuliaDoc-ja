```
maximum(f, itr; [init])
```

関数 `f` を `itr` の各要素に適用した結果の中で最大の値を返します。

空の `itr` に対して返される値は `init` で指定できます。これは `max` に対して中立的な要素でなければならず（すなわち、他のどの要素よりも小さいか等しい）、非空のコレクションに対して `init` が使用されるかどうかは未定義です。

!!! compat "Julia 1.6"
    キーワード引数 `init` は Julia 1.6 以降が必要です。


# 例

```jldoctest
julia> maximum(length, ["Julion", "Julia", "Jule"])
6

julia> maximum(length, []; init=-1)
-1

julia> maximum(sin, Real[]; init=-1.0)  # 良い、なぜなら sin の出力は >= -1
-1.0
```
