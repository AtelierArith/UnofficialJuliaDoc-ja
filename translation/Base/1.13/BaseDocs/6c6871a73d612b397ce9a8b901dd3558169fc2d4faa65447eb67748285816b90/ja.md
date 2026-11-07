```julia
memoryref(::GenericMemory, index::Integer)
memoryref(::GenericMemoryRef, index::Integer)
```

メモリオブジェクトとオフセットインデックス（1始まり。負の値も指定可能）から`GenericMemoryRef`を構築します。常に範囲内のオブジェクトを返し、インデックスによって基盤となるメモリの範囲外へのシフトが生じる場合はエラーをスローします。
