```julia
@invokelatest f(args...; kwargs...)
```

[`invokelatest`](@ref)を呼び出すための便利な方法を提供します。`@invokelatest f(args...; kwargs...)`は、単に`Base.invokelatest(f, args...; kwargs...)`に展開されます。

次の構文にも対応しています。

  * `@invokelatest x.f`は`Base.invokelatest(getproperty, x, :f)`に展開されます
  * `@invokelatest x.f = v`は`Base.invokelatest(setproperty!, x, :f, v)`に展開されます
  * `@invokelatest xs[i]`は`Base.invokelatest(getindex, xs, i)`に展開されます
  * `@invokelatest xs[i] = v`は`Base.invokelatest(setindex!, xs, v, i)`に展開されます

!!! note
    `f`がグローバル変数の場合、呼び出し先として（最新の）ワールドで一貫して解決されます。ただし、その他のすべての引数（および、リテラルなグローバル変数でない場合は`f`自体）は、現在のワールドエイジで評価されます。


!!! compat "Julia 1.7"
    このマクロにはJulia 1.7以降が必要です。


!!! compat "Julia 1.9"
    Julia 1.9より前のバージョンでは、このマクロはエクスポートされておらず、`Base.@invokelatest`として呼び出されていました。


!!! compat "Julia 1.10"
    追加された構文`x.f`および`xs[i]`には、Julia 1.10が必要です。

