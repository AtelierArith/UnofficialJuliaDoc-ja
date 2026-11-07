```julia
evalfile(path::AbstractString, args::Vector{String}=String[])
```

[`include`](@ref)を使ってファイルを無名モジュールに読み込み、すべての式を評価して、最後の式の値を返します。省略可能な`args`引数を使うと、スクリプトの入力引数（つまり、グローバルな`ARGS`変数）を設定できます。メソッドやグローバル変数などの定義は無名モジュール内で評価され、現在のモジュールには影響しません。

# Examples

```jldoctest
julia> write("testfile.jl", """
           @show ARGS
           1 + 1
       """);

julia> x = evalfile("testfile.jl", ["ARG1", "ARG2"]);
ARGS = ["ARG1", "ARG2"]

julia> x
2

julia> rm("testfile.jl")
```
