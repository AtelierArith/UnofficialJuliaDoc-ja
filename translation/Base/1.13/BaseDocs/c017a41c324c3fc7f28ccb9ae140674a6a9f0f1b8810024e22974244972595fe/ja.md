```julia
Expr(head::Symbol, args...)
```

パースされた Julia コード（AST）における複合式を表す型です。各式は、式の種類（関数呼び出し、for ループ、条件文など）を示す `head` `Symbol` と、部分式（関数呼び出しの引数など）で構成されます。部分式は、`Vector{Any}` 型の `args` フィールドに格納されます。

[Metaprogramming](@ref) に関するマニュアルの章と、開発者向けドキュメント [Julia ASTs](@ref) を参照してください。

# Examples

```jldoctest
julia> Expr(:call, :+, 1, 2)
:(1 + 2)

julia> dump(:(a ? b : c))
Expr
  head: Symbol if
  args: Array{Any}((3,))
    1: Symbol a
    2: Symbol b
    3: Symbol c
```
