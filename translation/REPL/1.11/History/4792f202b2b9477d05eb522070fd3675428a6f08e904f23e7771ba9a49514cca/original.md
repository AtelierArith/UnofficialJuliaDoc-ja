```julia
ConditionSet(spec::AbstractString) -> ConditionSet
```

Parse the raw search string `spec` into a `ConditionSet`.

Parsing is performed by splitting on unescaped `FILTER_SEPARATOR` and dispatching each segment according to its leading prefix character.
