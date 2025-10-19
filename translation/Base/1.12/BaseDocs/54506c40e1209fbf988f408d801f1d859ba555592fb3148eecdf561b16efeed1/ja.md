```julia
:expr
```

式 `expr` を引用し、`expr` の抽象構文木 (AST) を返します。AST は `Expr`、`Symbol`、またはリテラル値の型である可能性があります。構文 `:identifier` は `Symbol` に評価されます。

参照: [`Expr`](@ref), [`Symbol`](@ref), [`Meta.parse`](@ref)

# 例

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
