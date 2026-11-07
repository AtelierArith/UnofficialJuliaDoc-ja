```julia
UIntMappable(T::Type, order::Base.Order.Ordering)
```

`typeof(uint_map(x::T, order))` を返してください。[`uint_map`](@ref) と [`uint_unmap`](@ref) の両方が実装されている場合に限ります。

どちらか一方でも実装されていない場合は、`nothing` を返してください。
