```julia
AbstractMenu
```

The supertype for all Menu types.

# Functions

The following functions can be called on all <:AbstractMenu types. Details can be found in

## Exported

  * `request(m::AbstractMenu)`
  * `request(msg::AbstractString, m::AbstractMenu)`

## Hidden

  * `printmenu(m::AbstractMenu, cursor::Int; init::Bool=false, oldstate=nothing)`

# Subtypes

All subtypes must be mutable, and must contain the fields `pagesize::Int` and `pageoffset::Int`. They must also implement the following functions.

## Necessary Functions

These functions must be implemented for all subtypes of AbstractMenu.

  * `pick(m::AbstractMenu, cursor::Int)`
  * `cancel(m::AbstractMenu)`
  * `options(m::AbstractMenu)`   # `numoptions` is an alternative
  * `writeline(buf::IO, m::AbstractMenu, idx::Int, iscursor::Bool)`

If `m` does not have a field called `selected`, then you must also implement `selected(m)`.

## Optional Functions

These functions do not need to be implemented for all AbstractMenu subtypes.

  * `header(m::AbstractMenu)`
  * `keypress(m::AbstractMenu, i::UInt32)`
  * `numoptions(m::AbstractMenu)`
  * `selected(m::AbstractMenu)`
