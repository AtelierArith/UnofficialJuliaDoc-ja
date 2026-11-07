```julia
uripath(path::AbstractString)
```

Encode `path` as a URI as per [RFC8089: The "file" URI Scheme](https://www.rfc-editor.org/rfc/rfc8089), [RFC3986: Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986), and the [Freedesktop File URI spec](https://www.freedesktop.org/wiki/Specifications/file-uri-spec/).

## Examples

```julia-repl
julia> uripath("/home/user/example file.jl") # On a unix machine
"file://<hostname>/home/user/example%20file.jl"

julia> uripath("C:\Users\user\example file.jl") # On a windows machine
"file:///C:/Users/user/example%20file.jl"
```
