```julia
Base.rename(oldpath::AbstractString, newpath::AbstractString)
```

ファイルまたはディレクトリの名前を `oldpath` から `newpath` に変更します。`newpath` が既存のファイルまたは空のディレクトリであれば、置き換えられることがあります。Unix の [rename(2)](https://man7.org/linux/man-pages/man2/rename.2.html) と同等です。パスに「\0」が含まれている場合は `ArgumentError` をスローします。それ以外の失敗時には `IOError` をスローします。`newpath` を返します。

これは、[`mv`](@ref) の実装に使われる、低レベルのファイルシステム操作です。

`oldpath` と `newpath` が異なるディレクトリにある場合、OS 固有の制約が適用されることがあります。

Windows では現在、動作にいくつかの違いがあります。これらは将来のリリースで解消される可能性があります。具体的には、Windows では現在、次のようになります。

1. `rename` は、`oldpath` または `newpath` が開かれたファイルの場合、失敗します。
2. `rename` は、`newpath` が既存のディレクトリの場合、失敗します。
3. `rename` は、`newpath` がファイルで、`oldpath` がディレクトリの場合、成功することがあります。
4. `rename` は、`oldpath` が `newpath` へのハードリンクである場合、これを削除することがあります。

関連項目: [`mv`](@ref)。

!!! compat "Julia 1.12"
    このメソッドは Julia 1.12 で公開されました。

