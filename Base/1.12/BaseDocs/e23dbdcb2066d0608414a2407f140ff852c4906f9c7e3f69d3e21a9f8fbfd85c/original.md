```julia
module
```

`module` declares a [`Module`](@ref), which is a separate global variable workspace. Within a module, you can control which names from other modules are visible (via importing), and specify which of your names are intended to be public (via `export` and `public`). Modules allow you to create top-level definitions without worrying about name conflicts when your code is used together with somebody else’s. See the [manual section about modules](@ref modules) for more details.

# Examples

```julia
module Foo
import Base.show
export MyType, foo

struct MyType
    x
end

bar(x) = 2x
foo(a::MyType) = bar(a.x) + 1
show(io::IO, a::MyType) = print(io, "MyType $(a.x)")
end
```
