```
range(start, stop, length)
range(start, stop; length, step)
range(start; length, stop, step)
range(;start, length, stop, step)
```

引数から均等に間隔を空けた要素を持つ特化型配列（[`AbstractRange`](@ref)）を構築します。数学的には、範囲は `start`、`step`、`stop`、`length` のいずれか3つによって一意に決まります。範囲の有効な呼び出しは次のとおりです。

  * `start`、`step`、`stop`、`length` のいずれか3つを指定して `range` を呼び出します。
  * `start`、`stop`、`length` のいずれか2つを指定して `range` を呼び出します。この場合、`step` は1であると仮定されます。両方の引数が整数の場合、[`UnitRange`](@ref) が返されます。
  * `stop` または `length` のいずれか1つを指定して `range` を呼び出します。この場合、`start` と `step` は1であると仮定されます。

返される型に関する詳細は拡張ヘルプを参照してください。また、対数間隔の点については [`logrange`](@ref) も参照してください。

# 例

```jldoctest
julia> range(1, length=100)
1:100

julia> range(1, stop=100)
1:100

julia> range(1, step=5, length=100)
1:5:496

julia> range(1, step=5, stop=100)
1:5:96

julia> range(1, 10, length=101)
1.0:0.09:10.0

julia> range(1, 100, step=5)
1:5:96

julia> range(stop=10, length=5)
6:10

julia> range(stop=10, step=1, length=5)
6:1:10

julia> range(start=1, step=1, stop=10)
1:1:10

julia> range(; length = 10)
Base.OneTo(10)

julia> range(; stop = 6)
Base.OneTo(6)

julia> range(; stop = 6.5)
1.0:1.0:6.0
```

`length` が指定されておらず、`stop - start` が `step` の整数倍でない場合、`stop` より前で終了する範囲が生成されます。

```jldoctest
julia> range(1, 3.5, step=2)
1.0:2.0:3.0
```

中間値が合理的に計算されるように特別な配慮がなされています。この誘発されたオーバーヘッドを避けるために、[`LinRange`](@ref) コンストラクタを参照してください。

!!! compat "Julia 1.1"
    位置引数としての `stop` は少なくとも Julia 1.1 が必要です。


!!! compat "Julia 1.7"
    キーワード引数なしのバージョンと `start` をキーワード引数とするバージョンは少なくとも Julia 1.7 が必要です。


!!! compat "Julia 1.8"
    `stop` を唯一のキーワード引数とするバージョン、または `length` を唯一のキーワード引数とするバージョンは少なくとも Julia 1.8 が必要です。


# 拡張ヘルプ

`range` は引数が整数の場合、次の条件で `Base.OneTo` を生成します。

  * `length` のみが提供されている
  * `stop` のみが提供されている

`range` は引数が整数の場合、次の条件で `UnitRange` を生成します。

  * `start` と `stop` のみが提供されている
  * `length` と `stop` のみが提供されている

`step` が提供されている場合、たとえ1として指定されていても `UnitRange` は生成されません。
