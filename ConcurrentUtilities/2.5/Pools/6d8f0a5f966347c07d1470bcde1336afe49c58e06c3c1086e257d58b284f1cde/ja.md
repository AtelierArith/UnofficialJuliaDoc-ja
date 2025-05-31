```
release(pool::Pool{K, T}, key::K, obj::Union{T, Nothing}=nothing)
release(pool::Pool{K, T}, obj::T)
release(pool::Pool{K, T})
```

プールからオブジェクトの使用を解除します。提供されたキーでオプションとして解除されます。`obj`が提供されている場合、それは再利用のためにプールに戻されます。そうでない場合、`nothing`が返されるか、`release(pool)`が呼び出されると、オブジェクトが再利用のためにプールに戻されることなく使用カウントが減少します。
