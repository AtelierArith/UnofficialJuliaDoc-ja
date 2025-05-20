```
minimum(f, itr; [init])
```

関数 `f` を `itr` の各要素に適用した結果の最小値を返します。

空の `itr` に対して返される値は `init` で指定できます。これは `min` に対して中立的な要素でなければならず（すなわち、他のどの要素よりも大きいか等しい）、`init` が非空のコレクションに対して使用されるかどうかは未定義です。

!!! compat "Julia 1.6"
    キーワード引数 `init` は Julia 1.6 以降が必要です。


# 例

```jldoctest
julia> minimum(length, ["Julion", "Julia", "Jule"])
4

julia> minimum(length, []; init=typemax(Int64))
9223372036854775807

julia> minimum(sin, Real[]; init=1.0)  # 良い、sin の出力は <= 1 であるため
1.0
```
