```julia
splitpath(path::AbstractString) -> Vector{String}
```

ファイルパスをすべてのパスコンポーネントに分割します。これは `joinpath` の逆です。パス内の各ディレクトリまたはファイルに対して1つのサブストリングを含む配列を返し、ルートディレクトリが存在する場合はそれも含まれます。

!!! compat "Julia 1.1"
    この関数は少なくともJulia 1.1を必要とします。


# 例

```jldoctest
julia> splitpath("/home/myuser/example.jl")
4-element Vector{String}:
 "/"
 "home"
 "myuser"
 "example.jl"
```
