```
pwd() -> String
```

現在の作業ディレクトリを取得します。

参照: [`cd`](@ref), [`tempdir`](@ref).

# 例

```julia-repl
julia> pwd()
"/home/JuliaUser"

julia> cd("/home/JuliaUser/Projects/julia")

julia> pwd()
"/home/JuliaUser/Projects/julia"
```
