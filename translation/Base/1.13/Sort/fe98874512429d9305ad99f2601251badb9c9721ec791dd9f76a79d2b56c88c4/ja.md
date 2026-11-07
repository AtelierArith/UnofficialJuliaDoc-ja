```julia
uint_map(x, order::Base.Order.Ordering)::Unsigned
```

`x`を符号なし整数に変換し、ソート順を維持します。

この変換は[`uint_unmap`](@ref)で元に戻せる必要があるため、`isless(order, a, b)`は`a, b <: typeof(x)`の線形順序でなければなりません。`isless(order, a, b) === (uint_map(a, order) < uint_map(b, order))`および`x === uint_unmap(typeof(x), uint_map(x, order), order)`を満たします。

関連項目: [`UIntMappable`](@ref) [`uint_unmap`](@ref)
