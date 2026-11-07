```julia
*(s::Union{AbstractString, AbstractChar}, t::Union{AbstractString, AbstractChar}...)::AbstractString
```

文字列や文字を連結し、適切な [`String`](@ref) または [`AnnotatedString`](@ref) を生成します。これは、引数に対して [`string`](@ref) または [`annotatedstring`](@ref) 関数を呼び出すのと同じです。組み込みの文字列型を連結すると、常に `String` 型の値が生成されます。一方、その他の文字列型では、適切に異なる型の文字列を返す場合があります。

# Examples

```jldoctest
julia> "Hello " * "world"
"Hello world"

julia> 'j' * "ulia"
"julia"
```
