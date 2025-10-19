```julia
mkdir(path::AbstractString; mode::Unsigned = 0o777)
```

名前 `path` の新しいディレクトリを作成し、権限 `mode` を設定します。`mode` はデフォルトで `0o777` で、現在のファイル作成マスクによって変更されます。この関数は一度に1つのディレクトリしか作成しません。ディレクトリがすでに存在する場合や、中間ディレクトリのいくつかが存在しない場合、この関数はエラーをスローします。すべての必要な中間ディレクトリを作成する関数については [`mkpath`](@ref) を参照してください。`path` を返します。

# 例

```julia-repl
julia> mkdir("testingdir")
"testingdir"

julia> cd("testingdir")

julia> pwd()
"/home/JuliaUser/testingdir"
```
