```julia
mutable struct
```

`mutable struct`は[`struct`](@ref)に似ていますが、構築後に型のフィールドを設定できる点が異なります。

mutable structの個々のフィールドには`const`を指定して、不変にできます。

```julia
mutable struct Baz
    a::Int
    const b::Float64
end
```

!!! compat "Julia 1.8"
    mutable structのフィールドに対する`const`キーワードの使用には、Julia 1.8以降が必要です。


詳しくは、[Composite Types](@ref)に関するマニュアルの節を参照してください。
