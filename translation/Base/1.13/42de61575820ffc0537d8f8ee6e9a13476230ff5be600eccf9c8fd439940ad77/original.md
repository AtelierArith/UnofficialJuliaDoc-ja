```julia
checkbounds_indices(Bool, IA, I)
```

Return `true` if the "requested" indices in the tuple `I` fall within the bounds of the "permitted" indices specified by the tuple `IA`. This function recursively consumes elements of these tuples, usually in a 1-for-1 fashion,

```julia
checkbounds_indices(Bool, (IA1, IA...), (I1, I...)) = checkindex(Bool, IA1, I1) &
                                                      checkbounds_indices(Bool, IA, I)
```

Note that [`checkindex`](@ref) is being used to perform the actual bounds-check for a single dimension of the array.

There are two important exceptions to the 1-1 rule: linear indexing and CartesianIndex{N}, both of which may "consume" more than one element of `IA`.

See also [`checkbounds`](@ref).
