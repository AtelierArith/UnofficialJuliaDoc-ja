```
parse_pidfile(file::Union{IO, String}) => (pid, hostname, age)
```

私たちのpidfileフォーマットを解析しようとし、失敗した読み取りに対してそれぞれ(0, "", 0.0)に要素を置き換えました。
