```
loadface!(name::Symbol => update::Face)
```

Merge the face `name` in `FACES``.current` with `update`. If the face `name` does not already exist in `FACES``.current`, then it is set to `update`. To reset a face, `update` can be set to `nothing`.

# Examples

```jldoctest; setup = :(import StyledStrings: Face, loadface!)
julia> loadface!(:red => Face(foreground=0xff0000))
Face (sample)
    foreground: #ff0000
```
