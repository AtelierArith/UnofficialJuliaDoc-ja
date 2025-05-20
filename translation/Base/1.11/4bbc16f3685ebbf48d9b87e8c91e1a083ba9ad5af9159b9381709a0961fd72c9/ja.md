```
isconst(t::DataType, s::Union{Int,Symbol}) -> Bool
```

与えられた型 `t` において、フィールド `s` が `const` として宣言されているかどうかを判断します。
