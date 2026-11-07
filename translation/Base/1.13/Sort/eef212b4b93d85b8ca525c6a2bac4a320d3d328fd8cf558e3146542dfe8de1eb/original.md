```julia
send_to_end!(f::Function, v::AbstractVector; [lo, hi])
```

Send every element of `v` for which `f` returns `true` to the end of the vector and return the index of the last element for which `f` returns `false`.

`send_to_end!(f, v, lo, hi)` is equivalent to `send_to_end!(f, view(v, lo:hi))+lo-1`

Preserves the order of the elements that are not sent to the end.
