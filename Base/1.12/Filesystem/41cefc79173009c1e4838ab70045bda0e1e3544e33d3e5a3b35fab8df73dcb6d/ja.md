```julia
Base.rename(oldpath::AbstractString, newpath::AbstractString)
```

`oldpath`から`newpath`にファイルまたはディレクトリの名前を変更します。`newpath`が既存のファイルまたは空のディレクトリである場合は、置き換えられる可能性があります。Unixでの[rename(2)](https://man7.org/linux/man-pages/man2/rename.2.html)に相当します。パスに"\0"が含まれている場合は`ArgumentError`をスローします。他の失敗の場合は`IOError`をスローします。`newpath`を返します。

これは[`mv`](@ref)を実装するために使用される低レベルのファイルシステム操作です。

`oldpath`と`newpath`が異なるディレクトリにある場合、OS固有の制限が適用されることがあります。

現在、Windowsではいくつかの動作の違いがあり、将来のリリースで解決される可能性があります。具体的には、現在のWindowsでは：

1. `oldpath`または`newpath`が開いているファイルの場合、`rename`は失敗します。
2. `newpath`が既存のディレクトリの場合、`rename`は失敗します。
3. `newpath`がファイルで`oldpath`がディレクトリの場合、`rename`は成功する可能性があります。
4. `newpath`へのハードリンクである場合、`rename`は`oldpath`を削除する可能性があります。

参照：[`mv`](@ref)。

!!! compat "Julia 1.12"
    このメソッドはJulia 1.12で公開されました。

