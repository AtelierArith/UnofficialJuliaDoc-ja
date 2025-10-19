```julia
@show exs...
```

Prints one or more expressions, and their results, to `stdout`, and returns the last result.

See also: [`show`](@ref), [`@info`](@ref man-logging), [`println`](@ref).

# Examples

```jldoctest
julia> x = @show 1+2
1 + 2 = 3
3

julia> @show x^2 x/2;
x ^ 2 = 9
x / 2 = 1.5
```
