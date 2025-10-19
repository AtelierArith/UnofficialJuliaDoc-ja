```julia
*(s::Union{AbstractString, AbstractChar}, t::Union{AbstractString, AbstractChar}...) -> AbstractString
```

文字列や文字を連結し、[`String`](@ref) または [`AnnotatedString`](@ref)（適切に）を生成します。これは、引数に対して [`string`](@ref) または [`annotatedstring`](@ref) 関数を呼び出すことと同等です。組み込みの文字列型の連結は常に `String` 型の値を生成しますが、他の文字列型は適切に異なる型の文字列を返すことを選択する場合があります。

# 例

```jldoctest
julia> "Hello " * "world"
"Hello world"

julia> 'j' * "ulia"
"julia"
```
