```
cd(f::Function, dir::AbstractString=homedir())
```

一時的に現在の作業ディレクトリを `dir` に変更し、関数 `f` を適用し、最後に元のディレクトリに戻ります。

# 例

```julia-repl
julia> pwd()
"/home/JuliaUser"

julia> cd(readdir, "/home/JuliaUser/Projects/julia")
34-element Array{String,1}:
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
