```julia
Val(c)
```

実行時データを含まない`Val{c}()`を返します。このような型を使うと、`c`を介して関数間で情報を渡せます。この値は`isbits`値または`Symbol`でなければなりません。この構文の目的は、実行時に定数の値を調べることなく、コンパイル時に定数に基づいて直接ディスパッチできるようにすることです。

# Examples

```jldoctest
julia> f(::Val{true}) = "Good"
f (generic function with 1 method)

julia> f(::Val{false}) = "Bad"
f (generic function with 2 methods)

julia> f(Val(true))
"Good"
```
