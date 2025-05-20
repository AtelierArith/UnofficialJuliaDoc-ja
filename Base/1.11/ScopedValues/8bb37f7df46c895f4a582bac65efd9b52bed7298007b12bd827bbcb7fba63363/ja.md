```
@with (var::ScopedValue{T} => val)... expr
```

マクロ版の `with`。式 `@with var=>val expr` は、`var` が `val` に設定された新しい動的スコープで `expr` を評価します。`val` は型 `T` に変換されます。`@with var=>val expr` は `with(var=>val) do expr end` と同等ですが、`@with` はクロージャを作成することを避けます。

参照: [`ScopedValues.with`](@ref), [`ScopedValues.ScopedValue`](@ref), [`ScopedValues.get`](@ref)。

# 例

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
