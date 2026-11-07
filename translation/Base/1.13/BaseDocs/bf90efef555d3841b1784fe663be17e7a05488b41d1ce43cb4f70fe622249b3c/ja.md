```julia
...
```

「スプラット」演算子 `...` は、引数の列を表します。関数定義で `...` を使うと、任意の数の引数を受け取る関数を定義できます。また、`...` を使って、引数の列に関数を適用することもできます。

# Examples

```jldoctest
julia> add(xs...) = reduce(+, xs)
add (generic function with 1 method)

julia> add(1, 2, 3, 4, 5)
15

julia> add([1, 2, 3]...)
6

julia> add(7, 1:100..., 1000:1100...)
111107
```
