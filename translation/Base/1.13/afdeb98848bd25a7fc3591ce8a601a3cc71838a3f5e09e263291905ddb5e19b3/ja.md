```julia
reset(::Event)
```

[`Event`](@ref)を未設定の状態に戻します。その後は、[`notify`](@ref)が再度呼び出されるまで、`wait`の呼び出しはブロックされます。
