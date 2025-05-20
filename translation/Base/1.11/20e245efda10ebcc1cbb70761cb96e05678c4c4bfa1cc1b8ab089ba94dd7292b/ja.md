```
get!(f::Union{Function, Type}, collection, key)
```

指定されたキーに対して保存されている値を返します。キーに対するマッピングが存在しない場合は、`key => f()`を保存し、`f()`を返します。

これは`do`ブロック構文を使用して呼び出すことを意図しています。

# 例

```jldoctest
julia> squares = Dict{Int, Int}();

julia> function get_square!(d, i)
           get!(d, i) do
               i^2
           end
       end
get_square! (generic function with 1 method)

julia> get_square!(squares, 2)
4

julia> squares
Dict{Int64, Int64} with 1 entry:
  2 => 4
```
