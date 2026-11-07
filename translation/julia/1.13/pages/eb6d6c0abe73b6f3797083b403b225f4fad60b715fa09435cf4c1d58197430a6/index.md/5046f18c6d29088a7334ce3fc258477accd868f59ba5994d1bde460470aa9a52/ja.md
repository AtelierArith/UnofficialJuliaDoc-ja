# Lazy Artifacts

```@meta
DocTestSetup = :(using LazyArtifacts)
```

パッケージがアーティファクトを遅延ダウンロードできるようにするには、`LazyArtifacts`をそのパッケージの依存関係として明示的に指定する必要があります。

アーティファクトの詳細については、[Artifacts](@ref)を参照してください。
