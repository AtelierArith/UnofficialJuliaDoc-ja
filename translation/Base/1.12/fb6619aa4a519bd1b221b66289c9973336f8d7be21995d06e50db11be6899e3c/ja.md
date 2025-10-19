```julia
range(start, stop, length)
range(start, stop; length, step)
range(start; length, stop, step)
range(;start, length, stop, step)
```

引数から均等に間隔を空けた要素と最適化されたストレージを持つ特化型配列（[`AbstractRange`](@ref)）を構築します。数学的には、範囲は `start`、`step`、`stop`、`length` のいずれか3つによって一意に決定されます。範囲の有効な呼び出しは次のとおりです。

  * `start`、`step`、`stop`、`length` のいずれか3つを指定して `range` を呼び出します。
  * `start`、`stop`、`length` のいずれか2つを指定して `range` を呼び出します。この場合、`step` は正の1であると仮定されます。両方の引数が整数の場合、[`UnitRange`](@ref) が返されます。
  * `stop` または `length` のいずれか1つを指定して `range` を呼び出します。`start` と `step` は正の1であると仮定されます。

降順の範囲を構築するには、負のステップサイズを指定します。例：`range(5, 1; step = -1)` => [5,4,3,2,1]。そうでない場合、`stop` の値が `start` の値より小さく、デフォルトの `step` が `+1` の場合、空の範囲が構築されます。空の範囲は、`stop` が `start` より1小さいように正規化されます。例：`range(5, 1) == 5:4`。

返される型に関する詳細はExtended Helpを参照してください。また、対数間隔の点については [`logrange`](@ref) を参照してください。

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

`length` が指定されておらず、`stop - start` が `step` の整数倍でない場合、`stop` の手前で終了する範囲が生成されます。

```jldoctest
julia> range(1, 3.5, step=2)
1.0:2.0:3.0
```

中間値が合理的に計算されるように特別な配慮がなされています。この誘発されたオーバーヘッドを避けるために、[`LinRange`](@ref) コンストラクタを参照してください。

!!! compat "Julia 1.1"
    `stop` を位置引数として使用するには、少なくとも Julia 1.1 が必要です。


!!! compat "Julia 1.7"
    キーワード引数なしのバージョンと `start` をキーワード引数として使用するバージョンには、少なくとも Julia 1.7 が必要です。


!!! compat "Julia 1.8"
    `stop` を唯一のキーワード引数として使用するバージョン、または `length` を唯一のキーワード引数として使用するバージョンには、少なくとも Julia 1.8 が必要です。


# Extended Help

`range` は、引数が整数である場合に `Base.OneTo` を生成します。

  * `length` のみが提供されている場合
  * `stop` のみが提供されている場合

`range` は、引数が整数である場合に `UnitRange` を生成します。

  * `start` と `stop` のみが提供されている場合
  * `length` と `stop` のみが提供されている場合

`step` が指定されている場合、たとえそれが1として指定されていても、`UnitRange` は生成されません。
