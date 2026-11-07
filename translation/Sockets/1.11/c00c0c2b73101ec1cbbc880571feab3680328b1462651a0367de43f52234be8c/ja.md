```julia
islinklocaladdr(addr::IPAddr)
```

IPアドレスがリンクローカルアドレスかどうかを判定します。リンクローカルアドレスは、ネットワークセグメントを越えて一意であるとは限らないため、ルーターは転送しません。リンクローカルアドレスには、アドレスブロック `169.254.0.0/16` または `fe80::/10` が使用されます。

# Examples

```julia
filter(!islinklocaladdr, getipaddrs())
```
