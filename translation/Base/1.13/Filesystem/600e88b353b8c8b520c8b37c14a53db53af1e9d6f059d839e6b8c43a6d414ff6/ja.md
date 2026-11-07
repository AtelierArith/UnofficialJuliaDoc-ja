```julia
uperm(path)
uperm(path_elements...)
uperm(stat_struct)
```

`path` またはファイル記述子 `stat_struct` が示すファイルについて、所有者の権限をビットフィールドとして返します。

| 値   | 説明     |
|:--- |:------ |
| 01  | 実行権限   |
| 02  | 書き込み権限 |
| 04  | 読み取り権限 |

ビットフィールドが返されるため、読み取りと書き込みの権限がある場合、ビットフィールドは「110」となり、10進数では 0+2+4=6 に相当します。このことは、返された `UInt8` 値の表示にも反映されます。

[`gperm`](@ref) および [`operm`](@ref) も参照してください。

```jldoctest
julia> touch("dummy_file");  # Create test-file without contents

julia> uperm("dummy_file")
0x06

julia> bitstring(ans)
"00000110"

julia> has_read_permission(path) = uperm(path) & 0b00000100 != 0;  # Use bit mask to check specific bit

julia> has_read_permission("dummy_file")
true

julia> rm("dummy_file")     # Clean up test-file
```
