```
Pkg.why(pkg::Union{String, Vector{String}})
Pkg.why(pkg::Union{PackageSpec, Vector{PackageSpec}})
```

このパッケージがマニフェストに含まれている理由を示します。出力は、依存関係から始まる依存関係グラフを通じてパッケージに到達するさまざまな方法です。

!!! compat "Julia 1.9"
    この関数は少なくともJulia 1.9が必要です。

