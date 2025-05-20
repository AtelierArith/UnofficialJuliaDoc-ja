```
copyline(out::IO, io::IO=stdin; keep::Bool=false)
copyline(out::IO, filename::AbstractString; keep::Bool=false)
```

Copy a single line of text from an I/O `stream` or a file to the `out` stream, returning `out`.

When reading from a file, the text is assumed to be encoded in UTF-8. Lines in the input end with `'\n'` or `"\r\n"` or the end of an input stream. When `keep` is false (as it is by default), these trailing newline characters are removed from the line before it is returned. When `keep` is true, they are returned as part of the line.

Similar to [`readline`](@ref), which returns a `String`; in contrast, `copyline` writes directly to `out`, without allocating a string. (This can be used, for example, to read data into a pre-allocated [`IOBuffer`](@ref).)

See also [`copyuntil`](@ref) for reading until more general delimiters.

# Examples

```jldoctest
julia> write("my_file.txt", "JuliaLang is a GitHub organization.\nIt has many members.\n");

julia> String(take!(copyline(IOBuffer(), "my_file.txt")))
"JuliaLang is a GitHub organization."

julia> String(take!(copyline(IOBuffer(), "my_file.txt", keep=true)))
"JuliaLang is a GitHub organization.\n"

julia> rm("my_file.txt")
```
