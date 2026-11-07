```julia
ComposedFunction{Outer,Inner} <: Function
```

2つの呼び出し可能オブジェクト `outer::Outer` と `inner::Inner` の合成を表します。つまり、

```julia
ComposedFunction(outer, inner)(args...; kw...) === outer(inner(args...; kw...))
```

`ComposedFunction` のインスタンスを構築するには、合成演算子 [`∘`](@ref) を使うのが推奨されます。

```jldoctest
julia> sin ∘ cos === ComposedFunction(sin, cos)
true

julia> typeof(sin∘cos)
ComposedFunction{typeof(sin), typeof(cos)}
```

合成された要素は `ComposedFunction` のフィールドに格納されており、次のように取得できます。

```jldoctest
julia> composition = sin ∘ cos
sin ∘ cos

julia> composition.outer === sin
true

julia> composition.inner === cos
true
```

!!! compat "Julia 1.6"
    ComposedFunction を使用するには、Julia 1.6 以降が必要です。それ以前のバージョンでは、`∘` は代わりに無名関数を返します。


[`∘`](@ref) も参照してください。
