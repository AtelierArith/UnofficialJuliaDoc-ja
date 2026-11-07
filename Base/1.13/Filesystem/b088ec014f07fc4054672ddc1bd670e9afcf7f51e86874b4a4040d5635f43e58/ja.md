```julia
cd(f::Function, dir::AbstractString=homedir())
```

現在の作業ディレクトリを一時的に`dir`に変更し、関数`f`を適用した後、元のディレクトリに戻ります。

# Examples

```julia-repl
julia> pwd()
"/home/JuliaUser"

julia> cd(readdir, "/home/JuliaUser/Projects/julia")
34-element Vector{String}:
 ".circleci"
 ".freebsdci.sh"
 ".git"
 ".gitattributes"
 ".github"
 ⋮
 "test"
 "ui"
 "usr"
 "usr-staging"

julia> pwd()
"/home/JuliaUser"
```
