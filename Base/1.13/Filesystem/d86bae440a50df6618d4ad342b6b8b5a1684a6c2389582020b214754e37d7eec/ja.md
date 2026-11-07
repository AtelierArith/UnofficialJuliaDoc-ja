```julia
uripath(path::AbstractString)
```

`path` を、[RFC8089: The "file" URI Scheme](https://www.rfc-editor.org/rfc/rfc8089)、[RFC3986: Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986)、および [Freedesktop File URI spec](https://www.freedesktop.org/wiki/Specifications/file-uri-spec/) に従って URI としてエンコードします。

## Examples

```julia-repl
julia> uripath("/home/user/example file.jl") # On a unix machine
"file://<hostname>/home/user/example%20file.jl"

julia> uripath("C:\Users\user\example file.jl") # On a windows machine
"file:///C:/Users/user/example%20file.jl"
```
