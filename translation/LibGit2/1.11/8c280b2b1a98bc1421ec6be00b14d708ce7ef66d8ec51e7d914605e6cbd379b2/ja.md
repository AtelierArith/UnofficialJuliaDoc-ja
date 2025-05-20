```
LibGit2.Buffer
```

libgit2からデータをエクスポートするためのデータバッファ。[`git_buf`](https://libgit2.org/libgit2/#HEAD/type/git_buf)構造体に一致します。

LibGit2からデータを取得する際の典型的な使用法は次のようになります。

```julia
buf_ref = Ref(Buffer())
@check ccall(..., (Ptr{Buffer},), buf_ref)
# buf_refに対する操作
free(buf_ref)
```

特に、`Ref`オブジェクトに対してその後に`LibGit2.free`を呼び出す必要があることに注意してください。
