```julia
!f::Function
```

述語関数の否定: `!` の引数が関数の場合、`f` の真偽を反転する合成関数を返します。

[`∘`](@ref) も参照してください。

# Examples

```jldoctest
julia> str = "∀ ε > 0, ∃ δ > 0: |x-y| < δ ⇒ |f(x)-f(y)| < ε"
"∀ ε > 0, ∃ δ > 0: |x-y| < δ ⇒ |f(x)-f(y)| < ε"

julia> filter(isletter, str)
"εδxyδfxfyε"

julia> filter(!isletter, str)
"∀  > 0, ∃  > 0: |-| <  ⇒ |()-()| < "
```

!!! compat "Julia 1.9"
    Julia 1.9 以降では、`!f` は無名関数ではなく [`ComposedFunction`](@ref) を返します。

