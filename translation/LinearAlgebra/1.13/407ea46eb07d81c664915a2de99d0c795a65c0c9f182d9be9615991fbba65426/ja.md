```julia
symmetric_type(T::Type)
```

`symmetric(::T, ::Symbol)`が返すオブジェクトの型です。行列の場合は適切な型の`Symmetric`となり、`Number`の場合は元の型となります。カスタム型で`symmetric`を実装する場合は、`symmetric_type`も実装する必要があります。その逆も同様です。
