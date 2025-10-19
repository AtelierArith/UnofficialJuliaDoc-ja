```julia
release(pool::Pool{K, T}, key::K, obj::Union{T, Nothing}=nothing)
release(pool::Pool{K, T}, obj::T)
release(pool::Pool{K, T})
```

プールからオブジェクトを解放します。提供されたキーによってオプションでキー付けされます。`obj`が提供されている場合、それは再利用のためにプールに戻されます。そうでない場合、`nothing`が返されるか、`release(pool)`が呼び出されると、オブジェクトが再利用のためにプールに戻されることなく使用カウントが減少します。
