```
global
```

`global x` makes `x` in the current scope and its inner scopes refer to the global variable of that name. See the [manual section on variable scoping](@ref scope-of-variables) for more information.

# Examples

```jldoctest
julia> z = 3
3

julia> function foo()
           global z = 6 # use the z variable defined outside foo
       end
foo (generic function with 1 method)

julia> foo()
6

julia> z
6
```
