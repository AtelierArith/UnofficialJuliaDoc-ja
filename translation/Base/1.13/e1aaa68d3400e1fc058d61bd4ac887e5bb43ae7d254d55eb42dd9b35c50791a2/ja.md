```julia
parentmodule(t::DataType)::Module
```

（`UnionAll`で囲まれている可能性のある）`DataType`の定義を含むモジュールを特定します。

# Examples

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
