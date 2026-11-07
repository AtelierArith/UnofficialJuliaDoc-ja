```julia
include_string([mapexpr::Function,] m::Module, code::AbstractString, filename::AbstractString="string")
```

[`include`](@ref)と同様ですが、ファイルではなく、指定された文字列からコードを読み込みます。

省略可能な第1引数`mapexpr`を使うと、評価前に含まれるコードを変換できます。`code`内の各解析済み式`expr`について、`include_string`関数は実際に`mapexpr(expr)`を評価します。省略した場合、`mapexpr`の既定値は[`identity`](@ref)です。

!!! compat "Julia 1.5"
    `mapexpr`引数を渡すには、Julia 1.5が必要です。

