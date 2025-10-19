```julia
instances(T::Type)
```

指定された型のすべてのインスタンスのコレクションを返します。主に列挙型に使用されます（`@enum`を参照）。

# 例

```jldoctest
julia> @enum Color red blue green

julia> instances(Color)
(red, blue, green)
```
