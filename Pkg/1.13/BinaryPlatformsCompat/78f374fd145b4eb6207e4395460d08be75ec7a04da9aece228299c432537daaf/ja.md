```julia
platform_key_abi(machine::AbstractString)
```

現在のプラットフォームのキーを返します。また、`machine` パラメーターを使用すれば、別のプラットフォームのキーも取得できます。

このメソッドは非推奨です。`Base.BinaryPlatforms` をインポートし、現在のホストプラットフォームを取得するには `HostPlatform()` を、別のプラットフォームのトリプレットを解析するには `parse(Base.BinaryPlatforms.Platform, triplet)` を使用してください。
