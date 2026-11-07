```julia
Pkg.develop(pkg::Union{String, Vector{String}}; io::IO=stderr, preserve=PRESERVE_TIERED, installed=false)
Pkg.develop(pkgs::Union{PackageSpec, Vector{PackageSpec}}; io::IO=stderr, preserve=PRESERVE_TIERED, installed=false)
```

パッケージをパスで追跡して、開発用に利用できるようにします。`pkg`を名前のみ、またはURLで指定した場合、パッケージは環境変数`JULIA_PKG_DEVDIR`で指定された場所にダウンロードされます。指定がない場合は`joinpath(DEPOT_PATH[1],"dev")`が使われます。

`pkg`をローカルパスとして指定した場合、そのパスにあるパッケージが追跡対象になります。

`Pkg.add`で利用できる保持戦略は、`preserve`キーワード引数でも指定できます。詳しくは[`Pkg.add`](@ref)を参照してください。

# Examples

```julia
# By name
Pkg.develop("Example")

# By url
Pkg.develop(url="https://github.com/JuliaLang/Compat.jl")

# By path
Pkg.develop(path="MyJuliaPackages/Package.jl")
```

[`PackageSpec`](@ref)、[`Pkg.add`](@ref)も参照してください。
