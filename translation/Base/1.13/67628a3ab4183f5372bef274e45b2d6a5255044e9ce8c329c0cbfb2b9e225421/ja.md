```julia
get!(f::Union{Function, Type}, collection, key)
```

指定されたキーに対応する値を返します。キーに対応するマッピングが存在しない場合は、`key => f()`を格納して、`f()`を返します。

これは、`do`ブロック構文で呼び出すことを想定しています。

# Examples

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
