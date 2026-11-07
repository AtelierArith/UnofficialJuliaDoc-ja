```julia
open(filename::AbstractString, [mode::AbstractString]; lock = true)::IOStream
```

5つのブール値の代わりに、文字列でモードを指定する `mode` の別構文です。値は `fopen(3)` または Perl の `open` に対応し、次のブール値の組み合わせを設定するのと同等です。

| モード  | 説明                | キーワード                          |
|:---- |:----------------- |:------------------------------ |
| `r`  | 読み取り              | なし                             |
| `w`  | 書き込み、作成、切り詰め      | `write = true`                 |
| `a`  | 書き込み、作成、追記        | `append = true`                |
| `r+` | 読み取り、書き込み         | `read = true, write = true`    |
| `w+` | 読み取り、書き込み、作成、切り詰め | `truncate = true, read = true` |
| `a+` | 読み取り、書き込み、作成、追記   | `append = true, read = true`   |

`lock` キーワード引数は、安全なマルチスレッドアクセスのために操作をロックするかどうかを制御します。

# Examples

```jldoctest
julia> io = open("myfile.txt", "w");

julia> write(io, "Hello world!");

julia> close(io);

julia> io = open("myfile.txt", "r");

julia> read(io, String)
"Hello world!"

julia> write(io, "This file is read only")
ERROR: ArgumentError: write failed, IOStream is not writeable
[...]

julia> close(io)

julia> io = open("myfile.txt", "a");

julia> write(io, "This stream is not read only")
28

julia> close(io)

julia> rm("myfile.txt")
```

!!! compat "Julia 1.5"
    `lock` 引数は Julia 1.5 以降で使用できます。

