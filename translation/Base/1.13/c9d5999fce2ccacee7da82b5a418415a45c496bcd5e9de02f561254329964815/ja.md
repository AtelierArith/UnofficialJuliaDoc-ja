```julia
fieldindex(T, name::Symbol, err:Bool=true)
```

名前付きフィールドのインデックスを取得します。フィールドが存在しない場合、err==true ならエラーをスローし、err==false なら 0 を返します。

# Examples

```jldoctest
julia> struct Foo
           x::Int64
           y::String
       end

julia> fieldindex(Foo, :y)
2

julia> fieldindex(Foo, :z)
ERROR: FieldError: type Foo has no field `z`, available fields: `x`, `y`
Stacktrace:
[...]

julia> fieldindex(Foo, :z, false)
0
```

!!! compat "Julia 1.13"
    この関数は Julia 1.13 以降でエクスポートされています。

