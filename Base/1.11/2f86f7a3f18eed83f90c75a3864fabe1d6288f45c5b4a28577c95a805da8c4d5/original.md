```
ntuple(f, ::Val{N})
```

Create a tuple of length `N`, computing each element as `f(i)`, where `i` is the index of the element. By taking a `Val(N)` argument, it is possible that this version of ntuple may generate more efficient code than the version taking the length as an integer. But `ntuple(f, N)` is preferable to `ntuple(f, Val(N))` in cases where `N` cannot be determined at compile time.

# Examples

```jldoctest
julia> ntuple(i -> 2*i, Val(4))
(2, 4, 6, 8)
```
