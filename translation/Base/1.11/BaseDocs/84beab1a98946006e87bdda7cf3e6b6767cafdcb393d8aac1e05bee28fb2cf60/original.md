```
local
```

`local` introduces a new local variable. See the [manual section on variable scoping](@ref scope-of-variables) for more information.

# Examples

```jldoctest
julia> function foo(n)
           x = 0
           for i = 1:n
               local x # introduce a loop-local x
               x = i
           end
           x
       end
foo (generic function with 1 method)

julia> foo(10)
0
```
