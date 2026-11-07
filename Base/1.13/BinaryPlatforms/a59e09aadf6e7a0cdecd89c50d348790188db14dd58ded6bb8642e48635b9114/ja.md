```julia
platform_dlext(p::AbstractPlatform = HostPlatform())
```

指定されたプラットフォームの動的ライブラリ拡張子を返します。プラットフォームを指定しない場合は、現在実行中のプラットフォームが使用されます。たとえば、Linux 系のプラットフォームでは「so」、Windows 系のプラットフォームでは「dll」などが返されます。
