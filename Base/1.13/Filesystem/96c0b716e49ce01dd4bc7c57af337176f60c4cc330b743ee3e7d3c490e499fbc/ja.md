```julia
splitpath(path::AbstractString)::Vector{String}
```

ファイルパスをすべてのパス構成要素に分割します。これは`joinpath`の逆の操作です。パス内の各ディレクトリまたはファイルに対応する部分文字列を配列として返します。ルートディレクトリが含まれている場合は、それも含まれます。

!!! compat "Julia 1.1"
    この関数を使用するには、Julia 1.1 以降が必要です。


# Examples

```jldoctest
julia> splitpath("/home/myuser/example.jl")
4-element Vector{String}:
 "/"
 "home"
 "myuser"
 "example.jl"
```
