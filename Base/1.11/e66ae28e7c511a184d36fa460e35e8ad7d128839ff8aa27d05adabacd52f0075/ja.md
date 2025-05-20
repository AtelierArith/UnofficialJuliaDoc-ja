```
ComposedFunction{Outer,Inner} <: Function
```

二つの呼び出し可能なオブジェクト `outer::Outer` と `inner::Inner` の合成を表します。すなわち

```julia
ComposedFunction(outer, inner)(args...; kw...) === outer(inner(args...; kw...))
```

`ComposedFunction` のインスタンスを構築するための推奨される方法は、合成演算子 [`∘`](@ref) を使用することです：

```jldoctest
julia> sin ∘ cos === ComposedFunction(sin, cos)
true

julia> typeof(sin∘cos)
ComposedFunction{typeof(sin), typeof(cos)}
```

合成された部分は `ComposedFunction` のフィールドに格納され、次のように取得できます：

```jldoctest
julia> composition = sin ∘ cos
sin ∘ cos

julia> composition.outer === sin
true

julia> composition.inner === cos
true
```

!!! compat "Julia 1.6"
    `ComposedFunction` は少なくとも Julia 1.6 を必要とします。以前のバージョンでは `∘` は匿名関数を返します。


関連情報として [`∘`](@ref) を参照してください。
