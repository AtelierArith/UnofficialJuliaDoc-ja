```julia
chopprefix(s::AbstractString, prefix::Union{AbstractString,Regex,AbstractChar})::SubString
```

`s` から `prefix` を取り除きます。`s` が `prefix` で始まらない場合、`s` と等しい文字列を返します。

関連項目: [`chopsuffix`](@ref)。

!!! compat "Julia 1.8"
    この関数は Julia 1.8 以降で利用できます。


!!! compat "Julia 1.13"
    `AbstractChar` を受け取るメソッドは Julia 1.13 以降で利用できます。


# Examples

```jldoctest
julia> chopprefix("Hamburger", "Ham")
"burger"

julia> chopprefix("Hamburger", "hotdog")
"Hamburger"
```
