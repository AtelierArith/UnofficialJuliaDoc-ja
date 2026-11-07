```julia
set_active_project(projfile::Union{AbstractString,Nothing})
```

アクティブな`Project.toml`ファイルを`projfile`に設定します。[`Base.active_project`](@ref)も参照してください。

!!! compat "Julia 1.8"
    この関数を使用するには、Julia 1.8以降が必要です。

