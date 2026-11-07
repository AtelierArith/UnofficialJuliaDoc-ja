```julia
IterableStatePairs(x)
```

この内部型は、キーが`iterate`の状態と同じ場合に、[`pairs`](@ref)によって返されます。これにより、イテレーターは値に対してのみiterateを呼び出すことで、キー => 値のペアを判定できます。
