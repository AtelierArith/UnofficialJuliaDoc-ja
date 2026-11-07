```julia
Profile.Allocs.@profile [sample_rate=0.1] expr
```

`expr` の実行中に発生したメモリ割り当てをプロファイルし、結果と AllocResults 構造体の両方を返します。

サンプリングレートが 1.0 の場合はすべてを記録し、0.0 の場合は何も記録しません。

```julia
julia> Profile.Allocs.@profile sample_rate=0.01 peakflops()
1.03733270279065e11

julia> results = Profile.Allocs.fetch()

julia> last(sort(results.allocs, by=x->x.size))
Profile.Allocs.Alloc(Vector{Any}, Base.StackTraces.StackFrame[_new_array_ at array.c:127, ...], 5576)
```

詳しくは、Julia ドキュメントのプロファイリングチュートリアルを参照してください。

!!! compat "Julia 1.11"
    古いバージョンの Julia では、すべてのケースで型を取得できるわけではありませんでした。古いバージョンの Julia で、型 `Profile.Allocs.UnknownType` の割り当てが表示された場合、プロファイラーは割り当てられたオブジェクトの型を特定できていません。これは主に、コンパイラーが生成したコードから割り当てが発生した場合に起こります。詳しくは [issue #43688](https://github.com/JuliaLang/julia/issues/43688) を参照してください。

    Julia 1.11 以降では、すべての割り当てについて型が報告されるはずです。


!!! compat "Julia 1.8"
    割り当てプロファイラーは Julia 1.8 で追加されました。

