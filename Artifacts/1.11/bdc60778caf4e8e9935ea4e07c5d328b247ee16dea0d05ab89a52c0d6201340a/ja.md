```julia
process_overrides(artifact_dict::Dict, pkg_uuid::Base.UUID)
```

`Artifacts.toml` ファイルを読み込む際は、`Overrides.toml` ファイルを確認し、その中のアーティファクトが UUID によって上書きされていないかを調べる必要があります。上書きされている場合は、対象アーティファクトのハッシュを調べて、指定された上書き先を指すように変更し、実際のリダイレクト処理はハッシュベースの上書きシステムに委ねます。この処理によって `artifact_dict` オブジェクトが変更されることはありません。上書き対象の `Artifacts.toml` ファイルが読み込まれるたびに、ハッシュベースの上書きが動的に追加されるだけです。
