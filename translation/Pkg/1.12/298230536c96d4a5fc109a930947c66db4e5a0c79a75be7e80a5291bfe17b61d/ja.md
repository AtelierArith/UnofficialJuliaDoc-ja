```julia
Pkg.develop(pkg::Union{String, Vector{String}}; io::IO=stderr, preserve=PRESERVE_TIERED, installed=false)
Pkg.develop(pkgs::Union{PackageSpec, Vector{PackageSpec}}; io::IO=stderr, preserve=PRESERVE_TIERED, installed=false)
```

パッケージをパスで追跡することによって開発用に利用可能にします。`pkg` が名前または URL のみで指定された場合、パッケージは環境変数 `JULIA_PKG_DEVDIR` で指定された場所にダウンロードされ、デフォルトでは `joinpath(DEPOT_PATH[1],"dev")` になります。

`pkg` がローカルパスとして指定された場合、そのパスにあるパッケージが追跡されます。

`Pkg.add` によって提供される保存戦略は、`preserve` キーワード引数を介しても利用可能です。詳細については [`Pkg.add`](@ref) を参照してください。

# 例

```julia
# 名前で
Pkg.develop("Example")

# URLで
Pkg.develop(url="https://github.com/JuliaLang/Compat.jl")

# パスで
Pkg.develop(path="MyJuliaPackages/Package.jl")
```

他にも [`PackageSpec`](@ref)、[`Pkg.add`](@ref) を参照してください。
