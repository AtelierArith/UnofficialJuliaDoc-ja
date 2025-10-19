```julia
uperm(path)
uperm(path_elements...)
uperm(stat_struct)
```

`path`またはファイルディスクリプタ`stat_struct`に対するファイルの所有者権限のビットフィールドを返します。

| 値   | 説明     |
|:--- |:------ |
| 01  | 実行権限   |
| 02  | 書き込み権限 |
| 04  | 読み取り権限 |

ビットフィールドが返されるということは、権限が読み取り+書き込みの場合、ビットフィールドは"110"となり、これは10進数の値0+2+4=6に対応します。これは返された`UInt8`値の印刷に反映されます。

他に[`gperm`](@ref)および[`operm`](@ref)も参照してください。

```jldoctest
julia> touch("dummy_file");  # 内容のないテストファイルを作成

julia> uperm("dummy_file")
0x06

julia> bitstring(ans)
"00000110"

julia> has_read_permission(path) = uperm(path) & 0b00000100 != 0;  # ビットマスクを使用して特定のビットをチェック

julia> has_read_permission("dummy_file")
true

julia> rm("dummy_file")     # テストファイルをクリーンアップ
```
