```
Profile.Allocs.@profile [sample_rate=0.1] expr
```

`expr`の実行中に発生するプロファイルアロケーションを記録し、結果とAllocResults構造体の両方を返します。

サンプルレートが1.0の場合はすべてを記録し、0.0の場合は何も記録しません。

```julia
julia> Profile.Allocs.@profile sample_rate=0.01 peakflops()
1.03733270279065e11

julia> results = Profile.Allocs.fetch()

julia> last(sort(results.allocs, by=x->x.size))
Profile.Allocs.Alloc(Vector{Any}, Base.StackTraces.StackFrame[_new_array_ at array.c:127, ...], 5576)
```

詳細については、Juliaのドキュメントにあるプロファイリングチュートリアルを参照してください。

!!! compat "Julia 1.11"
    古いバージョンのJuliaでは、すべてのケースで型をキャプチャできませんでした。古いバージョンのJuliaで`Profile.Allocs.UnknownType`の型のアロケーションが見られた場合、それはプロファイラがどの型のオブジェクトがアロケートされたのかを知らないことを意味します。これは主に、コンパイラによって生成されたコードからのアロケーションが行われた場合に発生しました。詳細については[issue #43688](https://github.com/JuliaLang/julia/issues/43688)を参照してください。

    Julia 1.11以降、すべてのアロケーションには報告される型があるはずです。


!!! compat "Julia 1.8"
    アロケーションプロファイラはJulia 1.8で追加されました。

