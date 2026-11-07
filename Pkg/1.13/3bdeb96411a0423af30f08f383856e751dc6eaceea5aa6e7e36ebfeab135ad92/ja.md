```julia
Pkg.build(; verbose = false, io::IO=stderr)
Pkg.build(pkg::Union{String, Vector{String}}; verbose = false, io::IO=stderr)
Pkg.build(pkgs::Union{PackageSpec, Vector{PackageSpec}}; verbose = false, io::IO=stderr)
```

**キーワード引数:**

  * `verbose::Bool=false`: ビルド出力を`stdout`/`stderr`に出力し、`build.log`ファイルへのリダイレクトを行わない
  * `allow_reresolve::Bool=true`: ビルド環境内のパッケージバージョンをPkgが再解決できるようにする

!!! compat "Julia 1.13"
    `allow_reresolve`にはJulia 1.13以降が必要です。


`deps/build.jl`内のビルドスクリプトを実行し、`pkg`とそのすべての依存関係を深さ優先の再帰順でビルドします。`build`に引数を指定しない場合は、現在のプロジェクトがビルドされます。そのため、現在のプロジェクトはパッケージである必要があります。この関数は、初めてインストールされるパッケージに対して自動的に呼び出されます。

ビルドは、デフォルトで`startup-file=no`を使用する、現在のプロセスに対応した新しいプロセス内で実行されます。スタートアップファイル（`~/.julia/config/startup.jl`）を使用する場合は、明示的な`--startup-file=yes`を指定してjuliaを起動してください。
