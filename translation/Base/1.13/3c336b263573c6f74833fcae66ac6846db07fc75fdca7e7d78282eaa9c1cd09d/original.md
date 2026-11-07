```julia
annotated_chartransform(f::Function, str::AnnotatedString, state=nothing)
```

Transform every character in `str` with `f`, adjusting annotation regions as appropriate. `f` must take one of two forms, either:

  * `f(c::Char) -> Char`, or
  * `f(c::Char, state) -> (Char, state)`.

This works by comparing the number of code units of each character before and after transforming with `f`, recording and aggregating any differences, then applying them to the annotation regions.

Returns an `AnnotatedString{String}` (regardless of the original underling string type of `str`).
