```julia
x -> y
```

引数 `x` を関数本体 `y` に対応付ける無名関数を作成します。

```jldoctest
julia> f = x -> x^2 + 2x - 1
#1 (generic function with 1 method)

julia> f(2)
7
```

複数の引数を取る無名関数も定義できます。

```jldoctest
julia> g = (x,y) -> x^2 + y^2
#2 (generic function with 1 method)

julia> g(2,3)
13
```

詳しくは、[anonymous functions](@ref man-anonymous-functions) のマニュアルの節を参照してください。
