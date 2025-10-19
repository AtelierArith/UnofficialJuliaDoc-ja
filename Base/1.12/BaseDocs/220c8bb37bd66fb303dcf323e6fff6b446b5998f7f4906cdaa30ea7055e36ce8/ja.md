```julia
mutable struct
```

`mutable struct`は[`struct`](@ref)に似ていますが、構築後に型のフィールドを設定することも可能です。

ミュータブル構造体の個々のフィールドは、`const`としてマークすることで不変にすることができます：

```julia
mutable struct Baz
    a::Int
    const b::Float64
end
```

!!! compat "Julia 1.8"
    ミュータブル構造体のフィールドに対する`const`キーワードは、少なくともJulia 1.8が必要です。


詳細については、[Composite Types](@ref)のマニュアルセクションを参照してください。
