```
LibGit2.Callbacks
```

コールバック名をキーとし、コールバック関数とペイロードのタプルを値とする辞書。

`RemoteCallbacks`を構築するための`Callback`辞書は、各コールバックが異なるペイロードを使用できるようにします。各コールバックは呼び出されると、コールバックのカスタムペイロードを保持する`Dict`を受け取り、コールバック名を使用してアクセスできます。

# 例

```julia-repl
julia> c = LibGit2.Callbacks(:credentials => (LibGit2.credentials_cb(), LibGit2.CredentialPayload()));

julia> LibGit2.clone(url, callbacks=c);
```

サポートされているコールバックの詳細については、[`git_remote_callbacks`](https://libgit2.org/libgit2/#HEAD/type/git_remote_callbacks)を参照してください。
