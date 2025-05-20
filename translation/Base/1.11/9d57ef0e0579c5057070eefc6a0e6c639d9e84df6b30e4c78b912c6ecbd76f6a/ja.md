```
OrdinalRange{T, S} <: AbstractRange{T}
```

型 `T` の要素を持ち、型 `S` の間隔を持つ順序範囲のスーパークラス。ステップは常に [`oneunit`](@ref) の正確な倍数である必要があり、`T` は "離散的" な型でなければならず、`oneunit` より小さい値を持つことはできません。例えば、`Integer` や `Date` 型は適格ですが、`Float64` は適格ではありません（この型は `oneunit(Float64)` より小さい値を表すことができるため）。[`UnitRange`](@ref)、[`StepRange`](@ref)、およびその他の型はこのサブタイプです。
