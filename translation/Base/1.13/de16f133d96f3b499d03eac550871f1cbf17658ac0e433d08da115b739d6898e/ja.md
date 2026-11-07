```julia
range(start, stop, length)
range(start, stop; length, step)
range(start; length, stop, step)
range(;start, length, stop, step)
```

引数から、要素が等間隔に並び、効率的なストレージを使用する特殊な配列（[`AbstractRange`](@ref)）を構築します。数学的には、`start`、`step`、`stop`、`length`のうち任意の3つがあれば、範囲は一意に定まります。rangeの有効な呼び出し方は次のとおりです。

  * `start`、`step`、`stop`、`length`のうち任意の3つを指定して、`range`を呼び出します。
  * `start`、`stop`、`length`のうち2つを指定して、`range`を呼び出します。この場合、`step`は正の1とみなされます。両方の引数が整数の場合は、[`UnitRange`](@ref)が返されます。
  * `stop`または`length`のいずれかを指定して、`range`を呼び出します。`start`と`step`は正の1とみなされます。

降順の範囲を構築するには、負のステップ幅を指定します。例：`range(5, 1; step = -1)` => [5,4,3,2,1]。それ以外の場合、`stop`の値が`start`の値より小さく、`step`の既定値が`+1`であれば、空の範囲が構築されます。空の範囲は、`stop`が`start`より1小さくなるよう正規化されます。例：`range(5, 1) == 5:4`。

返される型の詳細については、拡張ヘルプを参照してください。対数間隔の点については、[`logrange`](@ref)も参照してください。

# Examples

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

`length`が指定されておらず、`stop - start`が`step`の整数倍でない場合、`stop`より前で終わる範囲が生成されます。

```jldoctest
julia> range(1, 3.5, step=2)
1.0:2.0:3.0
```

中間値が有理数として計算されるよう、特別な配慮がなされています。この処理によるオーバーヘッドを避けるには、[`LinRange`](@ref)コンストラクターを参照してください。

!!! compat "Julia 1.1"
    位置引数として`stop`を指定するには、Julia 1.1以降が必要です。


!!! compat "Julia 1.7"
    キーワード引数を使わない形式、およびキーワード引数として`start`を指定する形式には、Julia 1.7以降が必要です。


!!! compat "Julia 1.8"
    `stop`のみをキーワード引数として指定する形式、または`length`のみをキーワード引数として指定する形式には、Julia 1.8以降が必要です。


# Extended Help

引数が整数で、次のいずれかに該当する場合、`range`は`Base.OneTo`を生成します。

  * `length`のみが指定されている
  * `stop`のみが指定されている

引数が整数で、次のいずれかに該当する場合、`range`は`UnitRange`を生成します。

  * `start`と`stop`のみが指定されている
  * `length`と`stop`のみが指定されている

`step`が指定されている場合、値が1と指定されていても、`UnitRange`は生成されません。
