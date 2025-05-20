```
Pkg.build(; verbose = false, io::IO=stderr)
Pkg.build(pkg::Union{String, Vector{String}}; verbose = false, io::IO=stderr)
Pkg.build(pkgs::Union{PackageSpec, Vector{PackageSpec}}; verbose = false, io::IO=stderr)
```

`pkg`のビルドスクリプトを`deps/build.jl`で実行し、そのすべての依存関係を深さ優先の再帰的順序でビルドします。`build`に引数が与えられない場合、現在のプロジェクトがビルドされるため、これはパッケージである必要があります。この関数は、初めてインストールされるパッケージに対して自動的に呼び出されます。`verbose = true`は、ビルド出力を`stdout`/`stderr`に印刷し、`build.log`ファイルにリダイレクトするのではありません。
