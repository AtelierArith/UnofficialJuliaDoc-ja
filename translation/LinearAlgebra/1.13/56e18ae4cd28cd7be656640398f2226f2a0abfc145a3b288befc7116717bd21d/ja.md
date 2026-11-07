```julia
hermitian_type(T::Type)
```

`hermitian(::T, ::Symbol)` が返すオブジェクトの型です。行列の場合は適切な型の `Hermitian` となり、`Number` の場合は元の型となります。カスタム型で `hermitian` を実装する場合は、`hermitian_type` も実装する必要があり、その逆も同様です。
