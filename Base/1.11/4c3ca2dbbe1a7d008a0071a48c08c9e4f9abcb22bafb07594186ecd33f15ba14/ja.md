```
parentmodule(t::DataType) -> Module
```

定義されているモジュールを特定します（潜在的に `UnionAll` でラップされた） `DataType` の。

# 例

```jldoctest
julia> module Foo
           struct Int end
       end
Foo

julia> parentmodule(Int)
Core

julia> parentmodule(Foo.Int)
Foo
```
