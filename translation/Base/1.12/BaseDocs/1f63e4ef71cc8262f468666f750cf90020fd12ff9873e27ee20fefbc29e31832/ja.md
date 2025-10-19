```julia
x -> y
```

引数 `x` を関数本体 `y` にマッピングする匿名関数を作成します。

```jldoctest
julia> f = x -> x^2 + 2x - 1
#1 (generic function with 1 method)

julia> f(2)
7
```

匿名関数は複数の引数に対しても定義できます。

```jldoctest
julia> g = (x,y) -> x^2 + y^2
#2 (generic function with 1 method)

julia> g(2,3)
13
```

詳細については、[anonymous functions](@ref man-anonymous-functions) のマニュアルセクションを参照してください。
