```
for
```

`for` loops repeatedly evaluate a block of statements while iterating over a sequence of values.

The iteration variable is always a new variable, even if a variable of the same name exists in the enclosing scope. Use [`outer`](@ref) to reuse an existing local variable for iteration.

# Examples

```jldoctest
julia> for i in [1, 4, 0]
           println(i)
       end
1
4
0
```
