```julia
host_triplet()
```

`Sys.MACHINE`や、`libgfortran_version`、`libstdcxx_version`、`cxxstring_abi`などのコンパイラ ABI 値を検出する各種のイントロスペクション用ユーティリティから、ビルドホストのトリプレットを構築します。これらは、`Platform`の技術を使わずに実行します。ビルド済みのものがまだほとんどない段階で動作する必要があるためです。
