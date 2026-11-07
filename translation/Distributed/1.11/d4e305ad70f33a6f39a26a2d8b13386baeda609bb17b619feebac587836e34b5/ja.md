```julia
interrupt(pids::AbstractVector=workers())
```

指定したワーカー上で現在実行中のタスクを中断します。ローカルマシンで Ctrl-C を押すのと同じです。引数を指定しない場合は、すべてのワーカーが中断されます。
