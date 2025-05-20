```
ErrorException(msg)
```

Generic error type. The error message, in the `.msg` field, may provide more specific details.

# Examples

```jldoctest
julia> ex = ErrorException("I've done a bad thing");

julia> ex.msg
"I've done a bad thing"
```
