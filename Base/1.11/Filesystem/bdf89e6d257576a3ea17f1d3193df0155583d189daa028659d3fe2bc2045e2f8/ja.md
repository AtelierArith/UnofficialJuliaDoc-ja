```
readdir(dir::AbstractString=pwd();
    join::Bool = false,
    sort::Bool = true,
) -> Vector{String}
```

ディレクトリ `dir` の名前を返すか、指定されていない場合は現在の作業ディレクトリを返します。`join` が false の場合、`readdir` はディレクトリ内の名前をそのまま返します。`join` が true の場合、各 `name` に対して `joinpath(dir, name)` を返し、返される文字列はフルパスになります。絶対パスを取得したい場合は、絶対ディレクトリパスと `join` を true に設定して `readdir` を呼び出してください。

デフォルトでは、`readdir` は返す名前のリストをソートします。名前のソートをスキップしてファイルシステムがリストする順序で取得したい場合は、`readdir(dir, sort=false)` を使用してソートをオプトアウトできます。

関連情報: [`walkdir`](@ref)。

!!! compat "Julia 1.4"
    `join` および `sort` キーワード引数は少なくとも Julia 1.4 が必要です。


# 例

```julia-repl
julia> cd("/home/JuliaUser/dev/julia")

julia> readdir()
30-element Array{String,1}:
 ".appveyor.yml"
 ".git"
 ".gitattributes"
 ⋮
 "ui"
 "usr"
 "usr-staging"

julia> readdir(join=true)
30-element Array{String,1}:
 "/home/JuliaUser/dev/julia/.appveyor.yml"
 "/home/JuliaUser/dev/julia/.git"
 "/home/JuliaUser/dev/julia/.gitattributes"
 ⋮
 "/home/JuliaUser/dev/julia/ui"
 "/home/JuliaUser/dev/julia/usr"
 "/home/JuliaUser/dev/julia/usr-staging"

julia> readdir("base")
145-element Array{String,1}:
 ".gitignore"
 "Base.jl"
 "Enums.jl"
 ⋮
 "version_git.sh"
 "views.jl"
 "weakkeydict.jl"

julia> readdir("base", join=true)
145-element Array{String,1}:
 "base/.gitignore"
 "base/Base.jl"
 "base/Enums.jl"
 ⋮
 "base/version_git.sh"
 "base/views.jl"
 "base/weakkeydict.jl"

julia> readdir(abspath("base"), join=true)
145-element Array{String,1}:
 "/home/JuliaUser/dev/julia/base/.gitignore"
 "/home/JuliaUser/dev/julia/base/Base.jl"
 "/home/JuliaUser/dev/julia/base/Enums.jl"
 ⋮
 "/home/JuliaUser/dev/julia/base/version_git.sh"
 "/home/JuliaUser/dev/julia/base/views.jl"
 "/home/JuliaUser/dev/julia/base/weakkeydict.jl"
```
