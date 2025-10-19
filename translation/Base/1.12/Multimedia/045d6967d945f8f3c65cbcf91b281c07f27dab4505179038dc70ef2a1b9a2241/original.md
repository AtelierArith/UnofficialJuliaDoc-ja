```julia
displayable(mime) -> Bool
displayable(d::AbstractDisplay, mime) -> Bool
```

Return a boolean value indicating whether the given `mime` type (string) is displayable by any of the displays in the current display stack, or specifically by the display `d` in the second variant.
