```julia
asyncmap!(f, results, c...; ntasks=0, batch_size=nothing)
```

[`asyncmap`](@ref)と似ていますが、コレクションを返すのではなく、出力を`results`に格納します。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作になることがあります。

