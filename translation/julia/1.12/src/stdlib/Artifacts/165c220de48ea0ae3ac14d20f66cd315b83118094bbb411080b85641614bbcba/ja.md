```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/Artifacts/docs/src/index.md"
```

# Artifacts

```@meta
DocTestSetup = :(using Artifacts)
```

Julia 1.6から、アーティファクトのサポートは`Pkg.jl`からJulia自体に移動しました。ここに適切なドキュメントが追加されるまで、アーティファクトについては`Pkg.jl`マニュアルで詳しく学ぶことができます。[https://julialang.github.io/Pkg.jl/v1/artifacts/](https://julialang.github.io/Pkg.jl/v1/artifacts/)。

!!! compat "Julia 1.6"
    JuliaのアーティファクトAPIは、少なくともJulia 1.6が必要です。Juliaのバージョン1.3から1.5では、代わりに`Pkg.Artifacts`を使用できます。


```@docs
Artifacts.artifact_meta
Artifacts.artifact_hash
Artifacts.find_artifacts_toml
Artifacts.@artifact_str
Artifacts.artifact_exists
Artifacts.artifact_path
Artifacts.select_downloadable_artifacts
```
