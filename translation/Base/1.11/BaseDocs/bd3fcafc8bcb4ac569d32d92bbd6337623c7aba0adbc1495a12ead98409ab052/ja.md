```
Expr(head::Symbol, args...)
```

解析されたJuliaコード（AST）における複合式を表す型です。各式は、どの種類の式であるかを識別する`head` `Symbol`（例えば、呼び出し、forループ、条件文など）と、サブ式（例えば、呼び出しの引数）で構成されています。サブ式は、`args`という`Vector{Any}`フィールドに格納されます。

[メタプログラミング](@ref)に関するマニュアルの章と、開発者向けドキュメント[Julia ASTs](@ref)を参照してください。

# 例

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
