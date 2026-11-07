```julia
Base.rename(oldpath::AbstractString, newpath::AbstractString)
```

ファイルまたはディレクトリの名前を、`oldpath`から`newpath`に変更します。`newpath`が既存のファイルまたは空のディレクトリである場合は、置き換えられることがあります。Unixの[rename(2)](https://man7.org/linux/man-pages/man2/rename.2.html)と同等です。パスに「\0」が含まれている場合は、`ArgumentError`をスローします。それ以外のエラーが発生した場合は、`IOError`をスローします。`newpath`を返します。

これは、[`mv`](@ref)を実装するために使用される、低レベルのファイルシステム操作です。

`oldpath`と`newpath`が異なるディレクトリにある場合、OS固有の制約が適用されることがあります。

Windowsでは現在、動作にいくつかの違いがあります。これらは将来のリリースで解消される可能性があります。具体的には、現在のWindowsでは次のとおりです。

1. `rename`は、`oldpath`または`newpath`が開かれたファイルの場合、失敗します。
2. `rename`は、`newpath`が既存のディレクトリの場合、失敗します。
3. `rename`は、`newpath`がファイルで、`oldpath`がディレクトリの場合、成功することがあります。
4. `rename`は、`oldpath`が`newpath`へのハードリンクである場合、これを削除することがあります。

関連項目: [`mv`](@ref)。

!!! compat "Julia 1.12"
    このメソッドはJulia 1.12で公開されました。

