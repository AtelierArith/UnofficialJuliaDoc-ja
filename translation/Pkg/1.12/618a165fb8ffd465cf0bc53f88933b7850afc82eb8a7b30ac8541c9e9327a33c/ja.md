```julia
Pkg.why(pkg::Union{String, Vector{String}}; workspace::Bool=false)
Pkg.why(pkg::Union{PackageSpec, Vector{PackageSpec}}; workspace::Bool=false)
```

このパッケージがマニフェストに含まれている理由を示します。出力は、依存関係から始まる依存関係グラフを通じてパッケージに到達するためのすべての異なる方法です。`workspace`がtrueの場合、アクティブなプロジェクトだけでなく、ワークスペース内のすべてのプロジェクトが考慮されます。

!!! compat "Julia 1.9"
    この関数は少なくともJulia 1.9が必要です。

