```julia
symmetric_type(T::Type)
```

`symmetric(::T, ::Symbol)`によって返されるオブジェクトの型。行列の場合、これは適切に型付けされた`Symmetric`であり、`Number`の場合は元の型です。カスタム型に対して`symmetric`が実装されている場合、`symmetric_type`も実装されるべきであり、その逆も同様です。
