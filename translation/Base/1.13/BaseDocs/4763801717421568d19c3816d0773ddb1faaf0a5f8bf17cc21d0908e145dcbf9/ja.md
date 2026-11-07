```julia
where
```

`where` キーワードは、ある変数のすべての値にわたって他の型を反復的に合併したものと考えられる、[`UnionAll`](@ref) 型を作成します。たとえば、`Vector{T} where T<:Real` は、要素型が何らかの `Real` 数であるすべての [`Vector`](@ref) を含みます。

変数を省略した場合、上限はデフォルトで [`Any`](@ref) になります。

```julia
Vector{T} where T    # short for `where T<:Any`
```

変数には下限を指定することもできます。

```julia
Vector{T} where T>:Int
Vector{T} where Int<:T<:Real
```

入れ子になった `where` 式を簡潔に記述する構文もあります。たとえば、次の式は、

```julia
Pair{T, S} where S<:Array{T} where T<:Number
```

次のように短く書けます。

```julia
Pair{T, S} where {T<:Number, S<:Array{T}}
```

この形式は、メソッドシグネチャでよく使われます。

この形式では、変数は外側から内側の順に並べます。これは、`T{p1, p2, ...}` 構文を使って型をパラメーター値に「適用」するときに、変数が置き換えられる順序と一致します。
