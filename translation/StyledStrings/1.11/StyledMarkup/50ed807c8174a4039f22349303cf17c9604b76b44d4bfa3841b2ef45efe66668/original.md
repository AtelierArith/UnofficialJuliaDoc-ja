```julia
styerr!(state::State, message::AbstractString, position::Union{Nothing, Int}=nothing, hint::String="around here")
```

Register an error in `state` based on erroneous content at or around `position` (if known, and with a certain `hint` as to the location), with the nature of the error given by `message`.
