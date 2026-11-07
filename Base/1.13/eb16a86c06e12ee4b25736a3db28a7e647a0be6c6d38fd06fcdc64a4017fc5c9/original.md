```julia
delete_method(m::Method)
```

Make method `m` uncallable and force recompilation of any methods that use(d) it.
