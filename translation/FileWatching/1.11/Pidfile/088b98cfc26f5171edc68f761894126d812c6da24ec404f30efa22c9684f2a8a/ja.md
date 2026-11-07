```julia
parse_pidfile(file::Union{IO, String}) => (pid, hostname, age)
```

pidfile形式の解析を試み、読み取りに失敗した場合は、それぞれの要素を(0, "", 0.0)に置き換えました。
