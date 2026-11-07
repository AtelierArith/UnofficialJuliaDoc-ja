```julia
@with (var::ScopedValue{T} => val)... expr
```

`with`のマクロ版です。式`@with var=>val expr`は、新しい動的スコープ内で`expr`を評価し、その際`var`には`val`が設定されます。`val`は型`T`に変換されます。`@with var=>val expr`は`with(var=>val) do expr end`と同等ですが、`@with`ではクロージャが作成されません。

関連項目: [`ScopedValues.with`](@ref)、[`ScopedValues.ScopedValue`](@ref)、[`ScopedValues.get`](@ref)。

# Examples

```jldoctest
julia> using Base.ScopedValues

julia> const a = ScopedValue(1);

julia> f(x) = a[] + x;

julia> @with a=>2 f(10)
12

julia> @with a=>3 begin
           x = 100
           f(x)
       end
103
```
