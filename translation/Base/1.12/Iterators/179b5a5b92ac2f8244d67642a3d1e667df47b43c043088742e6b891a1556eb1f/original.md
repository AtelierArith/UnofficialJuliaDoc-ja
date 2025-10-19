```julia
Iterators.accumulate(f, itr; [init])
```

Given a 2-argument function `f` and an iterator `itr`, return a new iterator that successively applies `f` to the previous value and the next element of `itr`.

This is effectively a lazy version of [`Base.accumulate`](@ref).

!!! compat "Julia 1.5"
    Keyword argument `init` is added in Julia 1.5.


# Examples

```jldoctest
julia> a = Iterators.accumulate(+, [1,2,3,4]);

julia> foreach(println, a)
1
3
6
10

julia> b = Iterators.accumulate(/, (2, 5, 2, 5); init = 100);

julia> collect(b)
4-element Vector{Float64}:
 50.0
 10.0
  5.0
  1.0
```
