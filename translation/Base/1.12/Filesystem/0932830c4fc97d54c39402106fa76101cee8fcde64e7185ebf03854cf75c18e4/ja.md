```julia
splitext(path::AbstractString) -> (String, String)
```

パスの最後のコンポーネントに1つ以上のドットが含まれている場合、パスを最後のドットの前のすべての部分とドットを含むその後のすべての部分に分割します。そうでない場合は、引数を変更せずにタプルと空の文字列を返します。"splitext"は"split extension"の略です。

# 例

```jldoctest
julia> splitext("/home/myuser/example.jl")
("/home/myuser/example", ".jl")

julia> splitext("/home/myuser/example.tar.gz")
("/home/myuser/example.tar", ".gz")

julia> splitext("/home/my.user/example")
("/home/my.user/example", "")
```
