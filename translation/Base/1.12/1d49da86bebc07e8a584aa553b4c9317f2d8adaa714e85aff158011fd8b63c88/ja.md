```julia
!f::Function
```

述語関数の否定: `!` の引数が関数であるとき、それは `f` のブール否定を計算する合成関数を返します。

関連情報として [`∘`](@ref) を参照してください。

# 例

```jldoctest
julia> str = "∀ ε > 0, ∃ δ > 0: |x-y| < δ ⇒ |f(x)-f(y)| < ε"
"∀ ε > 0, ∃ δ > 0: |x-y| < δ ⇒ |f(x)-f(y)| < ε"

julia> filter(isletter, str)
"εδxyδfxfyε"

julia> filter(!isletter, str)
"∀  > 0, ∃  > 0: |-| <  ⇒ |()-()| < "
```

!!! compat "Julia 1.9"
    Julia 1.9 以降、`!f` は匿名関数の代わりに [`ComposedFunction`](@ref) を返します。

