```julia
tryparse(type, str; base)
```

[`parse`](@ref)と同様ですが、要求された型の値を返すか、文字列に有効な数値が含まれていない場合は[`nothing`](@ref)を返します。
