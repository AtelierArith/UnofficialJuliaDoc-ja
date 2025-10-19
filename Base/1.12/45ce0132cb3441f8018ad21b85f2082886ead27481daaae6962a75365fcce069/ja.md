```julia
evalfile(path::AbstractString, args::Vector{String}=String[])
```

ファイルを匿名モジュールに読み込み、[`include`](@ref)を使用してすべての式を評価し、最後の式の値を返します。オプションの`args`引数は、スクリプトの入力引数（すなわち、グローバル`ARGS`変数）を設定するために使用できます。定義（例：メソッド、グローバル）は匿名モジュール内で評価され、現在のモジュールには影響を与えないことに注意してください。

# 例

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
