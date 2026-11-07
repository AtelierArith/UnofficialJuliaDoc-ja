```julia
IterableStatePairs(x)
```

この内部型は、キーが`iterate`の状態と同じ場合に、[`pairs`](@ref)によって返されます。これにより、イテレーターは値に対してiterateを呼び出すだけで、キー => 値のペアを判定できます。
