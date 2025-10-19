```julia
@invokelatest f(args...; kwargs...)
```

[`invokelatest`](@ref)を呼び出すための便利な方法を提供します。`@invokelatest f(args...; kwargs...)`は単に`Base.invokelatest(f, args...; kwargs...)`に展開されます。

以下の構文もサポートしています：

  * `@invokelatest x.f`は`Base.invokelatest(getproperty, x, :f)`に展開されます
  * `@invokelatest x.f = v`は`Base.invokelatest(setproperty!, x, :f, v)`に展開されます
  * `@invokelatest xs[i]`は`Base.invokelatest(getindex, xs, i)`に展開されます
  * `@invokelatest xs[i] = v`は`Base.invokelatest(setindex!, xs, v, i)`に展開されます

!!! note
    `f`がグローバルである場合、呼び出しターゲットとして（最新の）ワールドで一貫して解決されます。しかし、他のすべての引数（および`f`自体がリテラルグローバルでない場合）は、現在のワールドエイジで評価されます。


!!! compat "Julia 1.7"
    このマクロはJulia 1.7以降が必要です。


!!! compat "Julia 1.9"
    Julia 1.9以前では、このマクロはエクスポートされておらず、`Base.@invokelatest`として呼び出されていました。


!!! compat "Julia 1.10"
    追加の`x.f`および`xs[i]`構文はJulia 1.10が必要です。

