```julia
@cfunction(callable, ReturnType, (ArgumentTypes...,)) -> Ptr{Cvoid}
@cfunction($callable, ReturnType, (ArgumentTypes...,)) -> CFunction
```

与えられた型シグネチャに対して、Julia関数 `callable` からC呼び出し可能な関数ポインタを生成します。戻り値を `ccall` に渡すには、シグネチャで引数の型 `Ptr{Cvoid}` を使用します。

引数の型タプルはリテラルタプルでなければならず、タプル値の変数や式ではありません（ただし、スプラット式を含むことはできます）。これらの引数はコンパイル時にグローバルスコープで評価されます（ランタイムまで遅延されることはありません）。関数引数の前に '$' を追加すると、ローカル変数 `callable` に対してランタイムクロージャを作成するように変更されます（これはすべてのアーキテクチャでサポートされているわけではありません）。

See [manual section on ccall and cfunction usage](@ref Calling-C-and-Fortran-Code).

# 例

```julia-repl
julia> function foo(x::Int, y::Int)
           return x + y
       end

julia> @cfunction(foo, Int, (Int, Int))
Ptr{Cvoid} @0x000000001b82fcd0
```
