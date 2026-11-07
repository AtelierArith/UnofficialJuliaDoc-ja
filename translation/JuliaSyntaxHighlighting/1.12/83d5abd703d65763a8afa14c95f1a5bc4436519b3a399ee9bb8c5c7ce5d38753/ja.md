```julia
highlight!(content::Union{AnnotatedString, SubString{AnnotatedString}},
           ast::JuliaSyntax.GreenNode = <parsed content>;
           syntax_errors::Bool = false) -> content
```

`content`に`JuliaSyntax`を適用して、構文ハイライトを行います。

デフォルトでは、`JuliaSyntax.parseall`を使って`ast`を生成し、キーワード引数`ignore_errors`には`true`を設定します。代わりに、事前に生成した`ast`を指定することもできます。

`syntax_errors`が設定されている場合、検出された構文エラーには`julia_error`フェイスが適用されます。

!!! warning
    `JuliaSyntax`で使用されるフェイスや、その適用方法は変更される可能性があることに注意してください。


# Examples

```jldoctest
julia> str = Base.AnnotatedString("sum(1:8)")
"sum(1:8)"

julia> JuliaSyntaxHighlighting.highlight!(str)
"sum(1:8)"

julia> Base.annotations(str)
6-element Vector{@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}}:
 @NamedTuple{region::UnitRange{Int64}, label::Symbol, value}((1:3, :face, :julia_funcall))
 @NamedTuple{region::UnitRange{Int64}, label::Symbol, value}((4:4, :face, :julia_rainbow_paren_1))
 @NamedTuple{region::UnitRange{Int64}, label::Symbol, value}((5:5, :face, :julia_number))
 @NamedTuple{region::UnitRange{Int64}, label::Symbol, value}((6:6, :face, :julia_operator))
 @NamedTuple{region::UnitRange{Int64}, label::Symbol, value}((7:7, :face, :julia_number))
 @NamedTuple{region::UnitRange{Int64}, label::Symbol, value}((8:8, :face, :julia_rainbow_paren_1))
```
