```julia
addface!(name::Symbol => default::Face)
```

Create a new face by the name `name`. So long as no face already exists by this name, `default` is added to both `FACES``.default` and (a copy of) to `FACES`.`current`, with the current value returned.

Should the face `name` already exist, `nothing` is returned.

# Examples

```jldoctest; setup = :(import StyledStrings: Face, addface!)
julia> addface!(:mypkg_myface => Face(slant=:italic, underline=true))
Face (sample)
         slant: italic
     underline: true
```
