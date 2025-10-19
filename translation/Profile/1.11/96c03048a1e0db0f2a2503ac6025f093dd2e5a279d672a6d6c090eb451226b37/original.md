```julia
Profile.add_fake_meta(data; threadid = 1, taskid = 0xf0f0f0f0) -> data_with_meta
```

The converse of `Profile.fetch(;include_meta = false)`; this will add fake metadata, and can be used for compatibility and by packages (e.g., FlameGraphs.jl) that would rather not depend on the internal details of the metadata format.
