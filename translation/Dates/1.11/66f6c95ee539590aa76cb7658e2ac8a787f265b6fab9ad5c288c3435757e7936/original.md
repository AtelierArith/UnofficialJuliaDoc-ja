```
tryparsenext_internal(::Type{<:TimeType}, str, pos, len, df::DateFormat, raise=false)
```

Parse the string according to the directives within the `DateFormat`. The specified `TimeType` type determines the type of and order of tokens returned. If the given `DateFormat` or string does not provide a required token a default value will be used. When the string cannot be parsed the returned value will be `nothing` if `raise` is false otherwise an exception will be thrown.

If successful, returns a 2-element tuple `(values, pos)`:

  * `values::Tuple`: A tuple which contains a value for each token as specified by the passed in type.
  * `pos::Int`: The character index at which parsing stopped.
