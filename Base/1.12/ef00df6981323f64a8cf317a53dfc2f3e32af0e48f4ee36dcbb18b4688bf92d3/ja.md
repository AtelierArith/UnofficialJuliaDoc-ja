```julia
showerror(io, e)
```

例外オブジェクト `e` の説明的な表現を表示します。このメソッドは、[`throw`](@ref) の呼び出し後に例外を表示するために使用されます。

# 例

```jldoctest
julia> struct MyException <: Exception
           msg::String
       end

julia> function Base.showerror(io::IO, err::MyException)
           print(io, "MyException: ")
           print(io, err.msg)
       end

julia> err = MyException("test exception")
MyException("test exception")

julia> sprint(showerror, err)
"MyException: test exception"

julia> throw(MyException("test exception"))
ERROR: MyException: test exception
```
