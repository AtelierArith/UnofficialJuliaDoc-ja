```
Meta.quot(ex)::Expr
```

式 `ex` を引用して、頭が `quote` の式を生成します。これは例えば、AST内の `Expr` 型のオブジェクトを表現するために使用できます。[QuoteNode](@ref man-quote-node) に関するマニュアルのセクションも参照してください。

# 例

```jldoctest
julia> eval(Meta.quot(:x))
:x

julia> dump(Meta.quot(:x))
Expr
  head: Symbol quote
  args: Array{Any}((1,))
    1: Symbol x

julia> eval(Meta.quot(:(1+2)))
:(1 + 2)
```
