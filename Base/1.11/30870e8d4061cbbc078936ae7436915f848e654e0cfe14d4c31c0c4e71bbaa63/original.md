```
|>(x, f)
```

Infix operator which applies function `f` to the argument `x`. This allows `f(g(x))` to be written `x |> g |> f`. When used with anonymous functions, parentheses are typically required around the definition to get the intended chain.

# Examples

```jldoctest
julia> 4 |> inv
0.25

julia> [2, 3, 5] |> sum |> inv
0.1

julia> [0 1; 2 3] .|> (x -> x^2) |> sum
14
```
