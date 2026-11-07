```julia
Profile.Allocs.@profile [sample_rate=0.1] expr
```

`expr`中に発生したメモリ割り当てをプロファイルし、結果とAllocResults構造体の両方を返します。

サンプリングレートが1.0の場合はすべて記録され、0.0の場合は何も記録されません。

```julia
julia> Profile.Allocs.@profile sample_rate=0.01 peakflops()
1.03733270279065e11

julia> results = Profile.Allocs.fetch()

julia> last(sort(results.allocs, by=x->x.size))
Profile.Allocs.Alloc(Vector{Any}, Base.StackTraces.StackFrame[_new_array_ at array.c:127, ...], 5576)
```

詳しくは、Juliaドキュメントのプロファイリングチュートリアルを参照してください。

!!! compat "Julia 1.11"
    古いバージョンのJuliaでは、すべてのケースで型を取得できるわけではありませんでした。古いバージョンのJuliaで、型が`Profile.Allocs.UnknownType`の割り当てが表示された場合、プロファイラーは割り当てられたオブジェクトの型を特定できていないことを意味します。これは主に、コンパイラーが生成したコードから割り当てが行われた場合に発生していました。詳しくは[issue #43688](https://github.com/JuliaLang/julia/issues/43688)を参照してください。

    Julia 1.11以降では、すべての割り当てについて型が報告されるはずです。


!!! compat "Julia 1.8"
    割り当てプロファイラーはJulia 1.8で追加されました。

