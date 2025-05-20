```
isreadable(io) -> Bool
```

指定されたIOオブジェクトが読み取り可能でない場合は`false`を返します。

# 例

```jldoctest
julia> open("myfile.txt", "w") do io
           print(io, "Hello world!");
           isreadable(io)
       end
false

julia> open("myfile.txt", "r") do io
           isreadable(io)
       end
true

julia> rm("myfile.txt")
```
