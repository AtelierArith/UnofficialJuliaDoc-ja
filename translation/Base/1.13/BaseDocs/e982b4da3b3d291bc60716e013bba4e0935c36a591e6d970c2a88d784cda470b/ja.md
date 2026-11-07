```julia
module
```

`module` は [`Module`](@ref) を宣言します。これは独立したグローバル変数のワークスペースです。モジュール内では、他のモジュールからどの名前を参照可能にするか（インポートによって）を制御でき、また、自分の名前のうちどれを公開するかを `export` と `public` によって指定できます。モジュールを使えば、自分のコードが他の人のコードと組み合わせて使われる場合でも、名前の衝突を気にせずトップレベルの定義を作成できます。詳しくは [manual section about modules](@ref modules) を参照してください。

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
