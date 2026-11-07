```julia
fieldoffset(type, name::Symbol | i::Integer)
```

型の先頭からの、フィールド（名前またはインデックスで指定）のバイトオフセット。

# Examples

```jldoctest
julia> struct Foo
           x::Int64
           y::String
       end

julia> fieldoffset(Foo, 2)
0x0000000000000008

julia> fieldoffset(Foo, :x)
0x0000000000000000
```

これを使って、構造体に関する情報をまとめられます。

```jldoctest
julia> structinfo(T) = [(fieldoffset(T,i), fieldname(T,i), fieldtype(T,i)) for i = 1:fieldcount(T)];

julia> structinfo(Base.Filesystem.StatStruct)
14-element Vector{Tuple{UInt64, Symbol, Type}}:
 (0x0000000000000000, :desc, Union{RawFD, String})
 (0x0000000000000008, :device, UInt64)
 (0x0000000000000010, :inode, UInt64)
 (0x0000000000000018, :mode, UInt64)
 (0x0000000000000020, :nlink, Int64)
 (0x0000000000000028, :uid, UInt64)
 (0x0000000000000030, :gid, UInt64)
 (0x0000000000000038, :rdev, UInt64)
 (0x0000000000000040, :size, Int64)
 (0x0000000000000048, :blksize, Int64)
 (0x0000000000000050, :blocks, Int64)
 (0x0000000000000058, :mtime, Float64)
 (0x0000000000000060, :ctime, Float64)
 (0x0000000000000068, :ioerrno, Int32)
```

!!! compat "Julia 1.13"
    インデックスではなく名前でフィールドを指定するには、Julia 1.13 以降が必要です。

