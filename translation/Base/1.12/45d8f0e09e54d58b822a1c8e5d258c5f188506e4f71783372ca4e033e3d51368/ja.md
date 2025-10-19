```julia
Val(c)
```

`Val{c}()`を返します。これは実行時データを含みません。このような型は、`c`の値を介して関数間で情報を渡すために使用できます。`c`は`isbits`値または`Symbol`でなければなりません。この構造の意図は、定数の値を実行時にテストすることなく、コンパイル時に直接定数に基づいてディスパッチできるようにすることです。

# 例

```jldoctest
julia> f(::Val{true}) = "Good"
f (generic function with 1 method)

julia> f(::Val{false}) = "Bad"
f (generic function with 2 methods)

julia> f(Val(true))
"Good"
```
