```julia
LibGit2.StrArrayStruct
```

文字列配列を表す LibGit2 の表現です。[`git_strarray`](https://libgit2.org/libgit2/#HEAD/type/git_strarray) 構造体に対応します。

LibGit2 からデータを取得する場合、一般的な使い方は次のとおりです。

```julia
sa_ref = Ref(StrArrayStruct())
@check ccall(..., (Ptr{StrArrayStruct},), sa_ref)
res = collect(sa_ref[])
free(sa_ref)
```

特に、`Ref` オブジェクトに対して、その後 `LibGit2.free` を呼び出す必要がある点に注意してください。

一方、文字列のベクトルを LibGit2 に渡す場合は、暗黙の変換を利用するのが一般に最も簡単です。

```julia
strs = String[...]
@check ccall(..., (Ptr{StrArrayStruct},), strs)
```

データは Julia によって割り当てられるため、`free` を呼び出す必要はありません。
