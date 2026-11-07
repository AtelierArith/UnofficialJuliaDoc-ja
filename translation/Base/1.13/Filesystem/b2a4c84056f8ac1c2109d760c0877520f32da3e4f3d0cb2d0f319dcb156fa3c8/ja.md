```julia
splitext(path::AbstractString) -> (path_without_extension::String, extension::String)
```

パスの最後の要素にドットが1つ以上含まれている場合は、最後のドットより前の部分と、最後のドットを含むそれ以降の部分に分割します。そうでない場合は、引数を変更せずに空文字列と組み合わせたタプルを返します。「splitext」は「split extension」の略です。

# Examples

```jldoctest
julia> splitext("/home/myuser/example.jl")
("/home/myuser/example", ".jl")

julia> splitext("/home/myuser/example.tar.gz")
("/home/myuser/example.tar", ".gz")

julia> splitext("/home/my.user/example")
("/home/my.user/example", "")
```
