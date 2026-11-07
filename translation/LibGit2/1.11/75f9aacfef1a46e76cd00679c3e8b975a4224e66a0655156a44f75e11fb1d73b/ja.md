```julia
LibGit2.Buffer
```

libgit2 からデータをエクスポートするためのデータバッファです。[`git_buf`](https://libgit2.org/libgit2/#HEAD/type/git_buf) 構造体に対応します。

LibGit2 からデータを取得する際の一般的な使用例は、次のとおりです。

```julia
buf_ref = Ref(Buffer())
@check ccall(..., (Ptr{Buffer},), buf_ref)
# operation on buf_ref
free(buf_ref)
```

特に、`Ref` オブジェクトに対して、その後 `LibGit2.free` を呼び出す必要がある点に注意してください。
