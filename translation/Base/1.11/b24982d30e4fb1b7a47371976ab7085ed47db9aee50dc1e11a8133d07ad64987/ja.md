```
nameof(t::DataType) -> Symbol
```

`DataType`（潜在的に `UnionAll` でラップされた） の名前を親モジュールなしでシンボルとして取得します。

# 例

```jldoctest
julia> module Foo
           struct S{T}
           end
       end
Foo

julia> nameof(Foo.S{T} where T)
:S
```
