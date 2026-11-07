```julia
nothing
```

返す値がない場合（C の `void` 関数など）や、変数またはフィールドに値がない場合に、慣例として使用される [`Nothing`](@ref) 型のシングルトンインスタンス。

`nothing` を返しても、REPL などの対話型環境には表示されません。

関連項目: [`isnothing`](@ref)、[`something`](@ref)、[`missing`](@ref)。
