```julia
Meta.quot(ex)::Expr
```

式 `ex` をクォートすると、ヘッドが `quote` の式が生成されます。これは、たとえば AST 内で型 `Expr` のオブジェクトを表すために使用できます。[QuoteNode](@ref man-quote-node) に関するマニュアルの節も参照してください。

# Examples

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
