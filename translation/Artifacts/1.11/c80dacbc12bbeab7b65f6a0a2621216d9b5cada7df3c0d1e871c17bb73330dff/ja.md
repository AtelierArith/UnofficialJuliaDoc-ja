```julia
ARTIFACT_OVERRIDES
```

アーティファクトの場所は、Pkgデポのアーティファクトディレクトリ内に`Overrides.toml`ファイルを作成することで上書きできます。たとえば、デフォルトのデポ`~/.julia`では、次の内容の`~/.julia/artifacts/Overrides.toml`ファイルを作成できます。

```julia
78f35e74ff113f02274ce60dab6e92b4546ef806 = "/path/to/replacement"
c76f8cda85f83a06d17de6c57aabf9e294eb2537 = "fb886e813a4aed4147d5979fcdf27457d20aa35d"

[d57dbccd-ca19-4d82-b9b8-9d660942965b]
c_simple = "/path/to/c_simple_dir"
libfoo = "fb886e813a4aed4147d5979fcdf27457d20aa35d""
```

このファイルでは、4つの上書きを定義しています。2つはコンテンツハッシュで識別される特定のアーティファクトを上書きし、残りの2つは特定のパッケージのUUID内で割り当てられた名前に基づいてアーティファクトを上書きします。どちらの場合も、上書き先には2種類あります。絶対パスで指定したディスク上の場所と、コンテンツハッシュで指定した別のアーティファクトです。
