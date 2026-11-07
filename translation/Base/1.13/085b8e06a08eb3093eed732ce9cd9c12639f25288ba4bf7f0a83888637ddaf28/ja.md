```julia
chopprefix(s::AbstractString, prefix::Union{AbstractString,Regex,AbstractChar})::SubString
```

`s` から `prefix` を取り除きます。`s` が `prefix` で始まらない場合は、`s` と等しい文字列が返されます。

関連項目: [`chopsuffix`](@ref)。

!!! compat "Julia 1.8"
    この関数は Julia 1.8 以降で利用できます。


!!! compat "Julia 1.13"
    `AbstractChar` の prefix を受け取るメソッドは Julia 1.13 以降で利用できます。


# Examples

```jldoctest
julia> chopprefix("Hamburger", "Ham")
"burger"

julia> chopprefix("Hamburger", "hotdog")
"Hamburger"
```
