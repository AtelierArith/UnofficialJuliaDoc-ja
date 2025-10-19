```julia
cd(dir::AbstractString=homedir())
```

現在の作業ディレクトリを設定します。

関連情報: [`pwd`](@ref), [`mkdir`](@ref), [`mkpath`](@ref), [`mktempdir`](@ref).

# 例

```julia-repl
julia> cd("/home/JuliaUser/Projects/julia")

julia> pwd()
"/home/JuliaUser/Projects/julia"

julia> cd()

julia> pwd()
"/home/JuliaUser"
```
