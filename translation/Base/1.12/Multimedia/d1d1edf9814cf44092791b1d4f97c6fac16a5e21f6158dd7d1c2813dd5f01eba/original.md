```julia
MIME
```

A type representing a standard internet data format. "MIME" stands for "Multipurpose Internet Mail Extensions", since the standard was originally used to describe multimedia attachments to email messages.

A `MIME` object can be passed as the second argument to [`show`](@ref) to request output in that format.

# Examples

```jldoctest
julia> show(stdout, MIME("text/plain"), "hi")
"hi"
```
