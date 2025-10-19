```julia
asyncmap!(f, results, c...; ntasks=0, batch_size=nothing)
```

[`asyncmap`](@ref)と同様ですが、コレクションを返すのではなく、`results`に出力を格納します。

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。

