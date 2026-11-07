# Handling Operating System Variation

クロスプラットフォームのアプリケーションやライブラリを作成する際は、オペレーティングシステムごとの差異に対応する必要が生じることがよくあります。このような場合には、変数 `Sys.KERNEL` を使用できます。これを容易にするため、`Sys` モジュールには、`isunix`、`islinux`、`isapple`、`isbsd`、`isfreebsd`、`iswindows` などの関数が用意されています。次のように使用できます。

```julia
if Sys.iswindows()
    windows_specific_thing(a)
end
```

`islinux`、`isapple`、`isfreebsd` は、`isunix` の互いに排他的な部分集合であることに注意してください。また、マクロ `@static` を使うと、次の例のように、これらの関数を利用して無効なコードを条件付きで隠すことができます。

単純なブロック:

```
ccall((@static Sys.iswindows() ? :_fopen : :fopen), ...)
```

複雑なブロック:

```julia
@static if Sys.islinux()
    linux_specific_thing(a)
elseif Sys.isapple()
    apple_specific_thing(a)
else
    generic_thing(a)
end
```

条件を入れ子にする場合は、各階層で `@static` を繰り返す必要があります（括弧は省略できますが、読みやすさのため付けることを推奨します）。

```julia
@static Sys.iswindows() ? :a : (@static Sys.isapple() ? :b : :c)
```
