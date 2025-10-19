```julia
memoryref(::GenericMemory, index::Integer)
memoryref(::GenericMemoryRef, index::Integer)
```

メモリオブジェクトとオフセットインデックス（1ベース、負の値も可）から`GenericMemoryRef`を構築します。これは常に境界内のオブジェクトを返し、そうでない場合（インデックスが基盤となるメモリの境界を超えるシフトを引き起こす場合）にはエラーをスローします。
