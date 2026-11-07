```julia
active_manifest()
active_manifest(project_file::AbstractString)
```

アクティブなマニフェストファイル、または指定した `project_file` に対して使用されるマニフェストファイルのパスを返します。

複数の環境がロードパス上に存在するスタック環境では、スタック内の他の環境のマニフェストではなく、プライマリ（アクティブ）環境のマニフェストファイルのみを返します。スタック環境の詳細については、マニュアルの [Environment stacks](@ref) の節を参照してください。

プロジェクトとマニフェストの違いや、パッケージのロード時に使われる名前の選択肢とその優先順位については、[`Project environments`](@ref project-environments) を参照してください。

[`Base.active_project`](@ref)、[`Base.set_active_project`](@ref) も参照してください。

!!! compat "Julia 1.13"
    この関数を使用するには、Julia 1.13 以降が必要です。

