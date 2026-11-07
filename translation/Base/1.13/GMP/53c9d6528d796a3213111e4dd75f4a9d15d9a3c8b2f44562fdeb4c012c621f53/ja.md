```julia
ALLOC_OVERFLOW_FUNCTION
```

真の場合、Julia が、巨大なメモリ割り当て時に異常終了せず、代わりに OutOfMemoryError をスローするようパッチされた GMP とリンクされていることを示す真偽値を保持する参照。
