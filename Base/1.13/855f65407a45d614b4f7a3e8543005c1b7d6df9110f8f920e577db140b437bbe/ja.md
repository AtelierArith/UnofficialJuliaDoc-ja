```julia
nameof(t::DataType)::Symbol
```

（`UnionAll`で囲まれている可能性のある）`DataType`の名前を、親モジュールを含めずにシンボルとして取得します。

# Examples

```jldoctest
julia> module Foo
           struct S{T}
           end
       end
Foo

julia> nameof(Foo.S{T} where T)
:S
```
