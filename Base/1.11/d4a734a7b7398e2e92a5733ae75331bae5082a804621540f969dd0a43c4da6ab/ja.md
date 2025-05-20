```
Base.locate_package(pkg::PkgId)::Union{String, Nothing}
```

識別子 `pkg` に対応するパッケージのエントリポイントファイルへのパス、または見つからない場合は `nothing`。詳細は [`identify_package`](@ref) を参照。

```julia-repl
julia> pkg = Base.identify_package("Pkg")
Pkg [44cfe95a-1eb2-52ea-b672-e2afdf69b78f]

julia> Base.locate_package(pkg)
"/path/to/julia/stdlib/v1.11/Pkg/src/Pkg.jl"
```
