```julia
LibGit2.StrArrayStruct
```

LibGit2の文字列配列の表現。[`git_strarray`](https://libgit2.org/libgit2/#HEAD/type/git_strarray)構造体に対応しています。

LibGit2からデータを取得する際の典型的な使用法は次のようになります：

```julia
sa_ref = Ref(StrArrayStruct())
@check ccall(..., (Ptr{StrArrayStruct},), sa_ref)
res = collect(sa_ref[])
free(sa_ref)
```

特に、`Ref`オブジェクトに対しては、その後に`LibGit2.free`を呼び出す必要があることに注意してください。

逆に、LibGit2に文字列のベクターを渡す場合、暗黙の変換に依存するのが一般的に最も簡単です：

```julia
strs = String[...]
@check ccall(..., (Ptr{StrArrayStruct},), strs)
```

データはJuliaによって割り当てられるため、`free`を呼び出す必要はないことに注意してください。
