```julia
highlight(content::Union{AbstractString, IO},
          ast::JuliaSyntax.GreenNode = <parsed content>;
          syntax_errors::Bool = false) -> AnnotatedString{String}
```

`content` に対して `JuliaSyntax` を使用して構文ハイライトを適用します。

デフォルトでは、`JuliaSyntax.parseall` が使用され、`ignore_errors` キーワード引数が `true` に設定されて `ast` が生成されます。あるいは、事前に生成された `ast` を提供することもできます。

`syntax_errors` が設定されている場合、検出された構文エラーには `julia_error` フェイスが適用されます。

!!! warning
    `JuliaSyntax` によって使用される特定のフェイスと、それらの適用方法は変更される可能性があります。


# 例

```jldoctest
julia> JuliaSyntaxHighlighting.highlight("sum(1:8)")
"sum(1:8)"

julia> JuliaSyntaxHighlighting.highlight("sum(1:8)") |> Base.annotations
5-element Vector{@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}}:
 @NamedTuple{region::UnitRange{Int64}, label::Symbol, value}((1:3, :face, :julia_funcall))
 @NamedTuple{region::UnitRange{Int64}, label::Symbol, value}((4:4, :face, :julia_rainbow_paren_1))
 @NamedTuple{region::UnitRange{Int64}, label::Symbol, value}((5:5, :face, :julia_number))
 @NamedTuple{region::UnitRange{Int64}, label::Symbol, value}((7:7, :face, :julia_number))
 @NamedTuple{region::UnitRange{Int64}, label::Symbol, value}((8:8, :face, :julia_rainbow_paren_1))
```
