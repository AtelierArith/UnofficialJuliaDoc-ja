```
hardlink(src::AbstractString, dst::AbstractString)
```

既存のソースファイル `src` に対して、名前 `dst` のハードリンクを作成します。宛先 `dst` は存在してはいけません。

関連: [`symlink`](@ref).

!!! compat "Julia 1.8"
    このメソッドは Julia 1.8 で追加されました。

