```julia
memoryref(::GenericMemory)
```

メモリオブジェクトから`GenericMemoryRef`を構築します。これは失敗しませんが、メモリが空の場合に限り、結果のメモリは範囲外を指します。
