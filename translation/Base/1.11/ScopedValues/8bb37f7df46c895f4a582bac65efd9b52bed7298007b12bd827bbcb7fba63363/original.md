```
@with (var::ScopedValue{T} => val)... expr
```

Macro version of `with`. The expression `@with var=>val expr` evaluates `expr` in a new dynamic scope with `var` set to `val`. `val` will be converted to type `T`. `@with var=>val expr` is equivalent to `with(var=>val) do expr end`, but `@with` avoids creating a closure.

See also: [`ScopedValues.with`](@ref), [`ScopedValues.ScopedValue`](@ref), [`ScopedValues.get`](@ref).

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
