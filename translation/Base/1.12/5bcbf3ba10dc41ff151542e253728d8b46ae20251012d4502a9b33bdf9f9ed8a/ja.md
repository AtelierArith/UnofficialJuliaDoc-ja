```julia
minimum(f, itr; [init])
```

`itr`の各要素に対して関数`f`を呼び出した結果の最小値を返します。

空の`itr`に対して返される値は`init`で指定できます。`init`は`min`の中立要素でなければならず（すなわち、他のどの要素よりも大きいか等しい必要があります）、非空のコレクションに対して`init`が使用されるかどうかは未定義です。

!!! compat "Julia 1.6"
    キーワード引数`init`はJulia 1.6以降が必要です。


# 例

```jldoctest
julia> minimum(length, ["Julion", "Julia", "Jule"])
4

julia> minimum(length, []; init=typemax(Int64))
9223372036854775807

julia> minimum(sin, Real[]; init=1.0)  # 良い、sinの出力は<= 1
1.0
```
