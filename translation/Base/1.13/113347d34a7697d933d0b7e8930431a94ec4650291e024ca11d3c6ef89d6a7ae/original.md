```julia
struct TermInfo
```

A parsed terminfo paired with capability information.

!!! warning



This is not part of the public API, and thus subject to change without notice.

# Fields

  * `names::Vector{String}`: The names this terminal is known by.
  * `flags::Int`: The number of flags specified.
  * `numbers::BitVector`: A mask indicating which of `TERM_NUMBERS` have been specified.
  * `strings::BitVector`: A mask indicating which of `TERM_STRINGS` have been specified.
  * `extensions::Vector{Symbol}`: A list of extended capability variable names.
  * `capabilities::Dict{Symbol, Union{Bool, Int, String}}`: The capability values themselves.

See also: `TermInfoRaw` and `TermCapability`.
