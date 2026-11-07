```julia
hardlink(src::AbstractString, dst::AbstractString)
```

既存のソースファイル `src` へのハードリンクを、名前 `dst` で作成します。リンク先の `dst` は存在していてはなりません。

関連項目: [`symlink`](@ref)。

!!! compat "Julia 1.8"
    このメソッドは Julia 1.8 で追加されました。

