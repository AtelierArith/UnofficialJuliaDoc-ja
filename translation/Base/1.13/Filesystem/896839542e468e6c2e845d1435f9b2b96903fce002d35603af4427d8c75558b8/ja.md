```julia
readdir(dir::AbstractString=pwd();
    join::Bool = false,
    sort::Bool = true,
)::Vector{String}
```

`dir` ディレクトリ内の名前を返します。ディレクトリが指定されていない場合は、現在の作業ディレクトリ内の名前を返します。`join` が false の場合、`readdir` はディレクトリ内の名前をそのまま返します。`join` が true の場合は、各 `name` に対して `joinpath(dir, name)` を返すため、返される文字列はフルパスになります。絶対パスを取得するには、絶対パスのディレクトリを指定して `join` を true に設定し、`readdir` を呼び出してください。

デフォルトでは、`readdir` は返す名前のリストをソートします。ソートを省略し、ファイルシステムが列挙する順序で名前を取得するには、`readdir(dir, sort=false)` を使ってソートを無効にできます。

関連項目: [`walkdir`](@ref)。

!!! compat "Julia 1.4"
    `join` および `sort` キーワード引数を使用するには、Julia 1.4 以降が必要です。


# Examples

```julia-repl
julia> cd("/home/JuliaUser/dev/julia")

julia> readdir()
30-element Vector{String}:
 ".appveyor.yml"
 ".git"
 ".gitattributes"
 ⋮
 "ui"
 "usr"
 "usr-staging"

julia> readdir(join=true)
30-element Vector{String}:
 "/home/JuliaUser/dev/julia/.appveyor.yml"
 "/home/JuliaUser/dev/julia/.git"
 "/home/JuliaUser/dev/julia/.gitattributes"
 ⋮
 "/home/JuliaUser/dev/julia/ui"
 "/home/JuliaUser/dev/julia/usr"
 "/home/JuliaUser/dev/julia/usr-staging"

julia> readdir("base")
145-element Vector{String}:
 ".gitignore"
 "Base.jl"
 "Enums.jl"
 ⋮
 "version_git.sh"
 "views.jl"
 "weakkeydict.jl"

julia> readdir("base", join=true)
145-element Vector{String}:
 "base/.gitignore"
 "base/Base.jl"
 "base/Enums.jl"
 ⋮
 "base/version_git.sh"
 "base/views.jl"
 "base/weakkeydict.jl"

julia> readdir(abspath("base"), join=true)
145-element Vector{String}:
 "/home/JuliaUser/dev/julia/base/.gitignore"
 "/home/JuliaUser/dev/julia/base/Base.jl"
 "/home/JuliaUser/dev/julia/base/Enums.jl"
 ⋮
 "/home/JuliaUser/dev/julia/base/version_git.sh"
 "/home/JuliaUser/dev/julia/base/views.jl"
 "/home/JuliaUser/dev/julia/base/weakkeydict.jl"
```
