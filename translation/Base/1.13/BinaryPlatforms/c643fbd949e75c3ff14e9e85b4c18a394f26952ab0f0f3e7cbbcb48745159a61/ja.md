```julia
os_version(p::AbstractPlatform)
```

この`Platform`オブジェクトで指定されているOSバージョンを取得します。OSバージョンが指定されていない場合、またはデータがない場合は、`nothing`を取得します。これは、プラットフォームSDKの断片化が激しく、特定のプラットフォームバージョンでのみ利用できる機能があるMacOSやFreeBSDのオブジェクトで、最もよく使われます。
