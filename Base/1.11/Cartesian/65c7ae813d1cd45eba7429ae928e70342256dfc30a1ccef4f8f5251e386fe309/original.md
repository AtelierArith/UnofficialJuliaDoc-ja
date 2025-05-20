```
@ncallkw N f kw sym...
```

Generate a function call expression with keyword arguments `kw...`. As in the case of [`@ncall`](@ref), `sym` represents any number of function arguments, the last of which may be an anonymous-function expression and is expanded into `N` arguments.

# Examples

```jldoctest
julia> using Base.Cartesian

julia> f(x...; a, b = 1, c = 2, d = 3) = +(x..., a, b, c, d);

julia> x_1, x_2 = (-1, -2); b = 0; kw = (c = 0, d = 0);

julia> @ncallkw 2 f (; a = 0, b, kw...) x
-3

```
