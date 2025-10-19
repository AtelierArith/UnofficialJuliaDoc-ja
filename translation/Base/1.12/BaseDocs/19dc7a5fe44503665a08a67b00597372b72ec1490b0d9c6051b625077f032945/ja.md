```julia
where
```

`where` キーワードは [`UnionAll`](@ref) 型を作成します。これは、ある変数のすべての値に対する他の型の反復的な和として考えることができます。例えば、`Vector{T} where T<:Real` は、要素型が何らかの `Real` 数であるすべての [`Vector`](@ref) を含みます。

変数の境界は省略された場合、デフォルトで [`Any`](@ref) になります：

```julia
Vector{T} where T    # `where T<:Any` の短縮形
```

変数には下限も設定できます：

```julia
Vector{T} where T>:Int
Vector{T} where Int<:T<:Real
```

ネストされた `where` 式のための簡潔な構文もあります。例えば、これ：

```julia
Pair{T, S} where S<:Array{T} where T<:Number
```

は次のように短縮できます：

```julia
Pair{T, S} where {T<:Number, S<:Array{T}}
```

この形式は、メソッドシグネチャでよく見られます。

この形式では、変数は外側から内側の順にリストされます。これは、型が `T{p1, p2, ...}` 構文を使用してパラメータ値に「適用」されるときに、変数が置き換えられる順序と一致します。
