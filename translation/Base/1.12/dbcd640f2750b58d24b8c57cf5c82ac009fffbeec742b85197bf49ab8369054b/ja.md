```julia
Base.identify_package(name::String)::Union{PkgId, Nothing}
Base.identify_package(where::Union{Module,PkgId}, name::String)::Union{PkgId, Nothing}
```

現在の環境スタックから名前でパッケージを特定し、その`PkgId`を返します。見つからない場合は`nothing`を返します。

`name`引数のみが提供された場合、スタック内の各環境とその名前付き直接依存関係を検索します。

`where`引数は、パッケージを検索するコンテキストを提供します。この場合、最初に名前がコンテキスト自体と一致するかを確認し、一致しない場合はすべての再帰的依存関係（各環境の解決されたマニフェストから）を検索し、コンテキスト`where`を見つけ、その後対応する名前の依存関係を特定します。

```julia-repl
julia> Base.identify_package("Pkg") # Pkgはデフォルト環境の依存関係です
Pkg [44cfe95a-1eb2-52ea-b672-e2afdf69b78f]

julia> using LinearAlgebra

julia> Base.identify_package(LinearAlgebra, "Pkg") # PkgはLinearAlgebraの依存関係ではありません
```
