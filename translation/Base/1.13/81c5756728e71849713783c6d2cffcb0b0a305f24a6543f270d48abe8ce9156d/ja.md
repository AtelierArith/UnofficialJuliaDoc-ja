```julia
Base.identify_package(name::String)::Union{PkgId, Nothing}
Base.identify_package(where::Union{Module,PkgId}, name::String)::Union{PkgId, Nothing}
```

現在の環境スタックから名前でパッケージを特定し、その`PkgId`を返します。見つからない場合は`nothing`を返します。

`name`引数だけが指定された場合、スタック内の各環境と、その環境に名前付きで直接依存するパッケージを検索します。

`where`引数は、パッケージの検索元となるコンテキストを指定します。この場合、まず名前がコンテキスト自体と一致するかを確認します。一致しなければ、各環境の解決済みマニフェストに記載されたすべての再帰的な依存関係を検索し、コンテキスト`where`を見つけます。そこから、対応する名前の依存パッケージを特定します。

```jldoctest
julia> Base.identify_package("Pkg") # Pkg is a dependency of the default environment
Pkg [44cfe95a-1eb2-52ea-b672-e2afdf69b78f]

julia> using LinearAlgebra

julia> Base.identify_package(LinearAlgebra, "Pkg") # Pkg is not a dependency of LinearAlgebra
```
