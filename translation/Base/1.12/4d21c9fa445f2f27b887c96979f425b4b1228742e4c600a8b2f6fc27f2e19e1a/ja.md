```julia
open(filename::AbstractString, [mode::AbstractString]; lock = true) -> IOStream
```

openの代替構文で、5つのブール値の代わりに文字列ベースのモード指定子が使用されます。`mode`の値は`fopen(3)`またはPerlの`open`からのもので、以下のブールグループを設定することに相当します。

| モード  | 説明                | キーワード                          |
|:---- |:----------------- |:------------------------------ |
| `r`  | 読み取り              | なし                             |
| `w`  | 書き込み、作成、切り捨て      | `write = true`                 |
| `a`  | 書き込み、作成、追加        | `append = true`                |
| `r+` | 読み取り、書き込み         | `read = true, write = true`    |
| `w+` | 読み取り、書き込み、作成、切り捨て | `truncate = true, read = true` |
| `a+` | 読み取り、書き込み、作成、追加   | `append = true, read = true`   |

`lock`キーワード引数は、安全なマルチスレッドアクセスのために操作がロックされるかどうかを制御します。

# 例

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
    `lock`引数はJulia 1.5以降で利用可能です。

