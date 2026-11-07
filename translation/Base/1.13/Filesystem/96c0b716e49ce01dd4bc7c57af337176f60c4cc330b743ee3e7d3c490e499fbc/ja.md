```julia
splitpath(path::AbstractString)::Vector{String}
```

ファイルパスをすべてのパス構成要素に分割します。これは`joinpath`の逆の操作です。パス内のディレクトリまたはファイルごとに1つの部分文字列を含む配列を返します。ルートディレクトリがある場合は、それも含まれます。

!!! compat "Julia 1.1"
    この関数を使用するには、Julia 1.1以降が必要です。


# Examples

```jldoctest
julia> splitpath("/home/myuser/example.jl")
4-element Vector{String}:
 "/"
 "home"
 "myuser"
 "example.jl"
```
