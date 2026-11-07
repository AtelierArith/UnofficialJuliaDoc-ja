```julia
make_scratch(scratch::Union{Nothing, Vector}, T::Type, len::Integer)
```

`t` が、長さが `len` 以上で、`Vector` `s` によってバックされた `T` 型の `AbstractVector` である `(s, t)` を返します。`scratch !== nothing` の場合は、`s === scratch` です。

`scratch === nothing` の場合、この関数は新しいベクトルを割り当てます。また、短すぎる場合は `resize!` `scratch` を、要素型が `T` でない場合は `reinterpret` `scratch` を割り当てます。
