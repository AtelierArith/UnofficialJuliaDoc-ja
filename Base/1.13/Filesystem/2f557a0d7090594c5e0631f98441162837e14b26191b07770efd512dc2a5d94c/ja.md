```julia
hardlink(src::AbstractString, dst::AbstractString)
```

既存のソースファイル `src` へのハードリンクを、`dst` という名前で作成します。リンク先の `dst` は存在していてはなりません。

関連項目: [`symlink`](@ref)。

!!! compat "Julia 1.8"
    このメソッドは Julia 1.8 で追加されました。

