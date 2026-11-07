```julia
Pkg.why(pkg::Union{String, Vector{String}}; workspace::Bool=false)
Pkg.why(pkg::Union{PackageSpec, Vector{PackageSpec}}; workspace::Bool=false)
```

このパッケージがマニフェストに含まれている理由を表示します。出力には、依存関係から始まり、依存関係グラフをたどってこのパッケージに至るすべての経路が表示されます。`workspace` が true の場合、アクティブなプロジェクトだけでなく、ワークスペース内のすべてのプロジェクトが対象になります。

!!! compat "Julia 1.9"
    この関数を使用するには、Julia 1.9 以降が必要です。

