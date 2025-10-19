```julia
OrdinalRange{T, S} <: AbstractRange{T}
```

要素の型 `T` と間隔の型 `S` を持つ順序範囲のスーパークラス。ステップは常に [`oneunit`](@ref) の正確な倍数である必要があり、`T` は "離散的" 型でなければならず、`oneunit` より小さい値を持つことはできません。例えば、`Integer` や `Date` 型は適格ですが、`Float64` は適格ではありません（この型は `oneunit(Float64)` より小さい値を表すことができるため）。[`UnitRange`](@ref)、[`StepRange`](@ref)、およびその他の型はこのサブタイプです。
