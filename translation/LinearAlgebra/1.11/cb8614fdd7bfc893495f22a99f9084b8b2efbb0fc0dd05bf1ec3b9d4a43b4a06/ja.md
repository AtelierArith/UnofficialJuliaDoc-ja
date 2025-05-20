```
hermitian_type(T::Type)
```

`hermitian(::T, ::Symbol)`によって返されるオブジェクトの型。行列の場合、これは適切に型付けされた`Hermitian`であり、`Number`の場合は元の型です。カスタム型に対して`hermitian`が実装されている場合、`hermitian_type`も実装されるべきであり、その逆も同様です。
