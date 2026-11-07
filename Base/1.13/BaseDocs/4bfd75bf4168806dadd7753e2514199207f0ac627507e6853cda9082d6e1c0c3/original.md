```julia
x -> y
```

Create an anonymous function mapping argument(s) `x` to the function body `y`.

```jldoctest
julia> f = x -> x^2 + 2x - 1
#1 (generic function with 1 method)

julia> f(2)
7
```

Anonymous functions can also be defined for multiple arguments.

```jldoctest
julia> g = (x,y) -> x^2 + y^2
#2 (generic function with 1 method)

julia> g(2,3)
13
```

See the manual section on [anonymous functions](@ref man-anonymous-functions) for more details.
