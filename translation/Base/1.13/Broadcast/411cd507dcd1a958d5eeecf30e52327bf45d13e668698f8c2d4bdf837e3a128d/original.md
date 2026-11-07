```julia
make_makeargs(t::Tuple)::Tuple{Vararg{Function}}
```

Each element of `t` is one (consecutive) node in a broadcast tree. The returned `Tuple` are functions which take in the (whole) flattened list and generate the inputs for the corresponding broadcasted function.
