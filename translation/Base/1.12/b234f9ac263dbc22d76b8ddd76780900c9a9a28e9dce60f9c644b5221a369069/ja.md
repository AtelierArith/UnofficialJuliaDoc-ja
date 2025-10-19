```julia
iswritable(io) -> Bool
```

指定されたIOオブジェクトが書き込み可能でない場合は`false`を返します。

# 例

```jldoctest
julia> open("myfile.txt", "w") do io
           print(io, "Hello world!");
           iswritable(io)
       end
true

julia> open("myfile.txt", "r") do io
           iswritable(io)
       end
false

julia> rm("myfile.txt")
```
