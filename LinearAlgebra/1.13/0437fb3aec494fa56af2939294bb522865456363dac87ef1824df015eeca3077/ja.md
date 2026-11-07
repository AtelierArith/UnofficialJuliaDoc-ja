```julia
hessenberg!(A) -> Hessenberg
```

`hessenberg!`は[`hessenberg`](@ref)と同じですが、コピーを作成せずに入力`A`を上書きするため、容量を節約できます。
