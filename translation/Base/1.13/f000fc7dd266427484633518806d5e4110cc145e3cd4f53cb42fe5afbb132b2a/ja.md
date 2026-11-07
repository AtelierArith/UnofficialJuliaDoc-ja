```julia
isconcretetype(T)
```

型 `T` が具象型かどうか、つまり直接インスタンス（`x` を満たす値 `typeof(x) === T`）を持ち得るかどうかを判定します。これは `isabstracttype(T)` の否定ではないことに注意してください。`T` が型でない場合は、`false` を返します。

!!! note
    具象型は [abstract](@ref isabstracttype) ではなく、その逆も成り立ちます。ただし、具象型でも抽象型でもない型もあります（たとえば、`Vector`（[`UnionAll`](@ref)））。


!!! note
    `T` は、`typeof` が返す型と完全に一致していなければなりません。型 `U` が存在し、`T == U`、`isconcretetype(T)` である一方、`!isconcretetype(U)` である場合もあります。


関連項目: [`isbits`](@ref)、[`isabstracttype`](@ref)、[`issingletontype`](@ref)。

# Examples

```jldoctest
julia> isconcretetype(Complex)
false

julia> isconcretetype(Complex{Float32})
true

julia> isconcretetype(Vector)
false

julia> isconcretetype(Vector{Complex})
true

julia> isconcretetype(Vector{Complex{Float32}})
true

julia> isconcretetype(Union{})
false

julia> isconcretetype(Union{Int,String})
false

julia> isconcretetype(Tuple{T} where T<:Int)
false
```
