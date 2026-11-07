```julia
instances(T::Type)
```

該当する場合、指定された型のすべてのインスタンスを返します。主に列挙型で使用されます（`@enum`を参照）。

# Examples

```jldoctest
julia> @enum Color red blue green

julia> instances(Color)
(red, blue, green)
```
