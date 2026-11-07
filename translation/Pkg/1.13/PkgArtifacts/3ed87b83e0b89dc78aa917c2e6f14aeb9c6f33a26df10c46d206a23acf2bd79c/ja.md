```julia
create_artifact(f::Function)
```

`f(artifact_path)`を実行して新しいアーティファクトを作成し、その結果をハッシュ化してアーティファクトストア（一般的なインストールでは`~/.julia/artifacts`）に移動します。このアーティファクトを識別するツリーハッシュを返します。
