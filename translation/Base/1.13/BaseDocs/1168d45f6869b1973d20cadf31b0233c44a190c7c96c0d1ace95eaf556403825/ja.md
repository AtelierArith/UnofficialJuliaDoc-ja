```julia
:expr
```

式 `expr` をクォートし、`expr` の抽象構文木（AST）を返します。AST の型は `Expr`、`Symbol`、またはリテラル値です。構文 `:identifier` は `Symbol` と評価されます。

関連項目: [`Expr`](@ref)、[`Symbol`](@ref)、[`Meta.parse`](@ref)

# Examples

```jldoctest
julia> expr = :(a = b + 2*x)
:(a = b + 2x)

julia> sym = :some_identifier
:some_identifier

julia> value = :0xff
0xff

julia> typeof((expr, sym, value))
Tuple{Expr, Symbol, UInt8}
```
