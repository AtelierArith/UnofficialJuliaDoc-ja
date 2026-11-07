```julia
UIntMappable(T::Type, order::Base.Order.Ordering)
```

`typeof(uint_map(x::T, order))` を返すのは、[`uint_map`](@ref) と [`uint_unmap`](@ref) の両方が実装されている場合です。

どちらか一方でも実装されていない場合は、`nothing` を返してください。
