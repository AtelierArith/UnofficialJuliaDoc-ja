```
tryparsenext_core(str::AbstractString, pos::Int, len::Int, df::DateFormat, raise=false)
```

Parse the string according to the directives within the `DateFormat`. Parsing will start at character index `pos` and will stop when all directives are used or we have parsed up to the end of the string, `len`. When a directive cannot be parsed the returned value will be `nothing` if `raise` is false otherwise an exception will be thrown.

If successful, return a 3-element tuple `(values, pos, num_parsed)`:

  * `values::Tuple`: A tuple which contains a value for each `DatePart` within the `DateFormat` in the order in which they occur. If the string ends before we finish parsing all the directives the missing values will be filled in with default values.
  * `pos::Int`: The character index at which parsing stopped.
  * `num_parsed::Int`: The number of values which were parsed and stored within `values`. Useful for distinguishing parsed values from default values.
