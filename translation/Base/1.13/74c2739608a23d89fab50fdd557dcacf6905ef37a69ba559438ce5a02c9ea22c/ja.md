```julia
OrdinalRange{T, S} <: AbstractRange{T}
```

要素の型が`T`で、間隔の型が`S`である序数範囲のスーパータイプです。ステップは常に[`oneunit`](@ref)の整数倍でなければならず、`T`は、`oneunit`より小さい値を取れない「離散」型である必要があります。たとえば、`Integer`や`Date`の型は該当しますが、`Float64`は該当しません（この型では`oneunit(Float64)`より小さい値を表現できるためです）。[`UnitRange`](@ref)、[`StepRange`](@ref)などの型は、この型のサブタイプです。
