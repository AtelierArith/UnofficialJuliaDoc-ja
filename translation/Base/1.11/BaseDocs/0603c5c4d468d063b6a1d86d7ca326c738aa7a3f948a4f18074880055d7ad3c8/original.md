```
function
```

Functions are defined with the `function` keyword:

```julia
function add(a, b)
    return a + b
end
```

Or the short form notation:

```julia
add(a, b) = a + b
```

The use of the [`return`](@ref) keyword is exactly the same as in other languages, but is often optional. A function without an explicit `return` statement will return the last expression in the function body.
