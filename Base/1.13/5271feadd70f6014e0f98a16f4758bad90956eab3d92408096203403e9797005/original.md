```julia
recursive_prefs_merge(base::Dict{String, Any}, overrides::Vector{Dict{String, Any}})
```

Helper function to merge preference dicts recursively, honoring overrides in nested dictionaries properly.
