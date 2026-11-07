```julia
for outer
```

Reuse an existing local variable for iteration in a `for` loop.

See the [manual section on variable scoping](@ref scope-of-variables) for more information.

See also [`for`](@ref).

# Examples

```jldoctest
julia> function f()
           i = 0
           for i = 1:3
               # empty
           end
           return i
       end;

julia> f()
0
```

```jldoctest
julia> function f()
           i = 0
           for outer i = 1:3
               # empty
           end
           return i
       end;

julia> f()
3
```

```jldoctest
julia> i = 0 # global variable
       for outer i = 1:3
       end
ERROR: syntax: no outer local variable declaration exists for "for outer"
[...]
```
