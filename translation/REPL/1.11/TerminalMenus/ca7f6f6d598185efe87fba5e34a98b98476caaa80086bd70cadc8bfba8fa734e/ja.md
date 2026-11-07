```julia
printmenu(out, m::AbstractMenu, cursoridx::Int; init::Bool=false, oldstate=nothing) -> newstate
```

メニューの状態を表示します。`init=true`を指定すると、`m.pageoffset`は、現在のカーソル位置またはそのすぐ上から印字を開始するように初期化されます。`init`がfalseの場合、端末は`m.pageoffset`の現在の設定を維持し、前回の表示を上書きします。`newstate`を返します。これを次回の呼び出しで`oldstate`として渡すと、前回の表示を正確に上書きできます。

!!! compat "Julia 1.6"
    `printmenu`にはJulia 1.6以降が必要です。

    それ以前のJuliaでは、これは`printMenu`という名前で、`state`引数／戻り値はありませんでした。この旧関数はすべてのJulia 1.xバージョンでサポートされていますが、Julia 2.0で削除される予定です。

