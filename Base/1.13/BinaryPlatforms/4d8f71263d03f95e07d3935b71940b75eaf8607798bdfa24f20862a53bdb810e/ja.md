```julia
HostPlatform()
```

現在のホストシステムに対応する `Platform` オブジェクトを返し、関連するすべての比較戦略をホストプラットフォームモードに設定します。これは次と同等です。

```julia
HostPlatform(parse(Platform, Base.BinaryPlatforms.host_triplet()))
```
