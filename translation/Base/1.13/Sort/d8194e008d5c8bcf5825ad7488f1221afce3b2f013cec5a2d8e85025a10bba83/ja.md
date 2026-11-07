```julia
uint_unmap(T::Type, u::Unsigned, order::Base.Order.Ordering)
```

`u`にuint*でマッピングされる一意の値`x::T`を復元します。`x === uint*unmap(T, uint_map(x::T, order), order)`for all`x <: T`を満たします。

関連項目: [`uint_map`](@ref) [`UIntMappable`](@ref)
