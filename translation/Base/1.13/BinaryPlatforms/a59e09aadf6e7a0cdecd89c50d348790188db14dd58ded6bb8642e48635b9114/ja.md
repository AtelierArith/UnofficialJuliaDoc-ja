```julia
platform_dlext(p::AbstractPlatform = HostPlatform())
```

指定されたプラットフォームの動的ライブラリ拡張子を返します。プラットフォームが指定されていない場合は、現在実行中のプラットフォームが使用されます。たとえば、Linux ベースのプラットフォームでは「so」、Windows ベースのプラットフォームでは「dll」などが返されます。
