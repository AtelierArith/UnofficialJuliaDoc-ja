```julia
isabstracttype(T)
```

型 `T` が抽象型として宣言されているか（つまり、`abstract type` 構文を使用しているか）を判定します。`T` が型でない場合は、`false` を返します。

!!! note
    抽象型は [concrete](@ref isconcretetype) ではなく、その逆も成り立ちません。一方、具体型でも抽象型でもない型もあります（たとえば、`Vector`（[`UnionAll`](@ref)））。


関連項目: [`isconcretetype`](@ref)。

# Examples

```jldoctest
julia> isabstracttype(AbstractArray)
true

julia> isabstracttype(Vector)
false
```
