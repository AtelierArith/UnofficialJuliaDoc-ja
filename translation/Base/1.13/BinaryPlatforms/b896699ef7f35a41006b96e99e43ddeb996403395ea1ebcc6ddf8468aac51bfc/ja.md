```julia
host_triplet()
```

`Sys.MACHINE`や、`libgfortran_version`、`libstdcxx_version`、`cxxstring_abi`などのコンパイラABI値を検出する各種のイントロスペクションユーティリティを使って、ビルドホストのトリプレットを構築します。これらの処理は、`Platform`の技術を使わずに行います。ビルドがまだほとんど進んでいない段階で実行する必要があるためです。
