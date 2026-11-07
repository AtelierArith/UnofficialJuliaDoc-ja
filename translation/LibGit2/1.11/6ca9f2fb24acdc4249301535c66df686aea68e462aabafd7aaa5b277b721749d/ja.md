```julia
LibGit2.Callbacks
```

コールバック名をキーとし、コールバック関数とペイロードのタプルを値とする辞書。

`Callback` 辞書を使って `RemoteCallbacks` を構築すると、各コールバックに個別のペイロードを渡せます。コールバックが呼び出されると、`Dict` を受け取ります。この値にはコールバック固有のペイロードが格納されており、コールバック名を使ってアクセスできます。

# Examples

```julia-repl
julia> c = LibGit2.Callbacks(:credentials => (LibGit2.credentials_cb(), LibGit2.CredentialPayload()));

julia> LibGit2.clone(url, callbacks=c);
```

サポートされているコールバックの詳細については、[`git_remote_callbacks`](https://libgit2.org/libgit2/#HEAD/type/git_remote_callbacks) を参照してください。
