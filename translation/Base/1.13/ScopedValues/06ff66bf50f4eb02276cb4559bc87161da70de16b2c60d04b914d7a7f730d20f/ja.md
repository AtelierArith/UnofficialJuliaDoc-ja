```julia
AbstractScopedValue{T}
```

動的スコープをまたいで値を伝播させる、スコープ付き値の抽象基底型です。すべてのスコープ付き値型は、この抽象型を継承する必要があります。

関連項目: [`ScopedValue`](@ref)、[`LazyScopedValue`](@ref)

!!! compat "Julia 1.13"
    AbstractScopedValue を使用するには、Julia 1.13 以降が必要です。

