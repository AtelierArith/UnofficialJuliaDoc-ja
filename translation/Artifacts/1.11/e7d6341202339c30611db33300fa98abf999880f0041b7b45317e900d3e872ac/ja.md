```
ARTIFACT_OVERRIDES
```

アーティファクトの場所は、Pkg デポのアーティファクトディレクトリ内に `Overrides.toml` ファイルを書くことで上書きできます。たとえば、デフォルトのデポ `~/.julia` では、次の内容を持つ `~/.julia/artifacts/Overrides.toml` ファイルを作成できます。

```
78f35e74ff113f02274ce60dab6e92b4546ef806 = "/path/to/replacement"
c76f8cda85f83a06d17de6c57aabf9e294eb2537 = "fb886e813a4aed4147d5979fcdf27457d20aa35d"

[d57dbccd-ca19-4d82-b9b8-9d660942965b]
c_simple = "/path/to/c_simple_dir"
libfoo = "fb886e813a4aed4147d5979fcdf27457d20aa35d""
```

このファイルは、特定のアーティファクトをそのコンテンツハッシュを通じて上書きする2つと、特定のパッケージのUUID内でのバウンド名に基づいてアーティファクトを上書きする2つの合計4つの上書きを定義しています。いずれの場合も、上書きの2つの異なるターゲットがあります：絶対パスを通じてディスク上の場所に上書きすることと、コンテンツハッシュによって別のアーティファクトに上書きすることです。
