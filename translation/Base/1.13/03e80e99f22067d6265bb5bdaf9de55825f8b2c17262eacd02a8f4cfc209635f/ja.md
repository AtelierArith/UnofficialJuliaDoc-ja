```julia
@cfunction(callable, ReturnType, (ArgumentTypes...,)) -> Ptr{Cvoid}
@cfunction($callable, ReturnType, (ArgumentTypes...,)) -> CFunction
```

指定した型シグネチャに対応する、Julia 関数 `callable` から C で呼び出し可能な関数ポインターを生成します。戻り値を `ccall` に渡すには、シグネチャで引数型 `Ptr{Cvoid}` を使用します。

引数型のタプルはリテラルでなければならず、タプル値を持つ変数や式は指定できません（ただし、スプラット式を含めることはできます）。また、これらの引数は実行時まで評価が遅延されるのではなく、コンパイル時にグローバルスコープで評価されます。関数引数の前に「$」を付けると、代わりにローカル変数 `callable` をキャプチャする実行時クロージャーが作成されます（すべてのアーキテクチャでサポートされているわけではありません）。

[manual section on ccall and cfunction usage](@ref Calling-C-and-Fortran-Code) を参照してください。

# Examples

```julia-repl
julia> function foo(x::Int, y::Int)
           return x + y
       end

julia> @cfunction(foo, Int, (Int, Int))
Ptr{Cvoid} @0x000000001b82fcd0
```
