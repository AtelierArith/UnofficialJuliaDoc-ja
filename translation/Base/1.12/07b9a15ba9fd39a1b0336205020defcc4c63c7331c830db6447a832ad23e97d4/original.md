```julia
join([io::IO,] iterator [, delim [, last]])
```

Join any `iterator` into a single string, inserting the given delimiter (if any) between adjacent items.  If `last` is given, it will be used instead of `delim` between the last two items.  Each item of `iterator` is converted to a string via `print(io::IOBuffer, x)`. If `io` is given, the result is written to `io` rather than returned as a `String`.

# Examples

```jldoctest
julia> join(["apples", "bananas", "pineapples"], ", ", " and ")
"apples, bananas and pineapples"

julia> join([1,2,3,4,5])
"12345"
```
