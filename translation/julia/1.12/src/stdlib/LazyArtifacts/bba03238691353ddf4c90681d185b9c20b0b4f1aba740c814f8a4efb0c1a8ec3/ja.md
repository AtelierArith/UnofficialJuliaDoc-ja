# Lazy Artifacts

```@meta
DocTestSetup = :(using LazyArtifacts)
```

パッケージがアーティファクトを遅延ダウンロードするためには、`LazyArtifacts`をそのパッケージの依存関係として明示的にリストする必要があります。

アーティファクトに関する詳細は、[Artifacts](@ref)を参照してください。
