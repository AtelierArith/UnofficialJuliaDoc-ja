```julia
chopsuffix(s::AbstractString, suffix::Union{AbstractString,Regex,AbstractChar})::SubString
```

`s` から `suffix` を取り除きます。`s` が `suffix` で終わっていない場合は、`s` と等しい文字列が返されます。

関連項目: [`chopprefix`](@ref)。

!!! compat "Julia 1.8"
    この関数は Julia 1.8 以降で利用できます。


!!! compat "Julia 1.13"
    `AbstractChar` を受け取るメソッドは Julia 1.13 以降で利用できます。


# Examples

```jldoctest
julia> chopsuffix("Hamburger", "er")
"Hamburg"

julia> chopsuffix("Hamburger", "hotdog")
"Hamburger"
```
