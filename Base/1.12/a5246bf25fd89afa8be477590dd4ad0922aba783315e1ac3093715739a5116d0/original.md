```julia
isconst(t::DataType, s::Union{Int,Symbol}) -> Bool
```

Determine whether a field `s` is const in a given type `t` in the sense that a read from said field is consistent for egal objects. Note in particular that out-of-bounds fields are considered const under this definition (because they always throw).
