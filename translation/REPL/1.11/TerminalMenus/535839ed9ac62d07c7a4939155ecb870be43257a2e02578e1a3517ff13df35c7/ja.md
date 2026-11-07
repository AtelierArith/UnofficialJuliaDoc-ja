```julia
cancel(m::AbstractMenu)
```

ユーザーがメニューをキャンセル（'q' または ctrl-c）したときの動作を定義します。`request()` は、この関数を呼び出した後、常に終了します。
