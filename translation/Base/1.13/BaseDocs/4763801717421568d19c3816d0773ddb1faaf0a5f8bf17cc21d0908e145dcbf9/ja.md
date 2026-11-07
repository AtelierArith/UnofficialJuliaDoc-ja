```julia
where
```

`where`キーワードは[`UnionAll`](@ref)型を作成します。この型は、ある変数のすべての値について、ほかの型を反復的に和集合したものと考えることができます。たとえば、`Vector{T} where T<:Real`には、要素型が何らかの`Real`数であるすべての[`Vector`](@ref)が含まれます。

変数の上限を省略した場合、デフォルトで[`Any`](@ref)になります。

```julia
Vector{T} where T    # short for `where T<:Any`
```

変数には下限を指定することもできます。

```julia
Vector{T} where T>:Int
Vector{T} where Int<:T<:Real
```

入れ子になった`where`式を簡潔に記述する構文もあります。たとえば、次の式は

```julia
Pair{T, S} where S<:Array{T} where T<:Number
```

次のように短縮できます。

```julia
Pair{T, S} where {T<:Number, S<:Array{T}}
```

この形式は、メソッドシグネチャでよく使われます。

この形式では、変数は外側のものから順に並べます。これは、`T{p1, p2, ...}`構文を使って型をパラメーター値に「適用」するときに、変数が置き換えられる順序と一致します。
