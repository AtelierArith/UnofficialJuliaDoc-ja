```julia
struct TermInfoRaw
```

A structured representation of a terminfo file, without any knowledge of particular capabilities, solely based on `term(5)`.

!!! warning



This is not part of the public API, and thus subject to change without notice.

# Fields

  * `names::Vector{String}`: The names this terminal is known by.
  * `flags::BitVector`: A list of 0–44 flag values.
  * `numbers::Union{Vector{Int16}, Vector{Int32}}`: A list of 0–39 number values. A value of `typemax(eltype(numbers))` is used to skip over unspecified capabilities while ensuring value indices are correct.
  * `strings::Vector{Union{String, Nothing}}`: A list of 0–414 string values. A value of `nothing` is used to skip over unspecified capabilities while ensuring value indices are correct.
  * `extended::Union{Nothing, Dict{Symbol, Union{Bool, Int, String}}}`: Should an extended info section exist, this gives the entire extended info as a dictionary. Otherwise `nothing`.

See also: `TermInfo` and `TermCapability`.
