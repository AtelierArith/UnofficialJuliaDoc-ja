```julia
islinklocaladdr(addr::IPAddr)
```

IPアドレスがリンクローカルアドレスかどうかを判定します。リンクローカルアドレスは、ネットワークセグメントを越えて一意であることが保証されないため、ルーターは転送しません。リンクローカルアドレスは、アドレスブロック `169.254.0.0/16` または `fe80::/10` に属します。

# Examples

```julia
filter(!islinklocaladdr, getipaddrs())
```
