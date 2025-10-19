```julia
include_string([mapexpr::Function,] m::Module, code::AbstractString, filename::AbstractString="string")
```

[`include`](@ref)と同様ですが、ファイルからではなく、指定された文字列からコードを読み込みます。

オプションの最初の引数`mapexpr`は、評価される前に含まれるコードを変換するために使用できます：`code`内の各解析された式`expr`について、`include_string`関数は実際に`mapexpr(expr)`を評価します。省略した場合、`mapexpr`は[`identity`](@ref)にデフォルト設定されます。

!!! compat "Julia 1.5"
    `mapexpr`引数を渡すにはJulia 1.5が必要です。

