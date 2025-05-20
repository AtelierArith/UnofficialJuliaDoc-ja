```
module
```

`module` は [`Module`](@ref) を宣言し、これは別のグローバル変数のワークスペースです。モジュール内では、他のモジュールからどの名前が見えるかを制御（インポートを通じて）し、あなたの名前のうちどれが公開されることを意図しているかを指定できます（`export` と `public` を通じて）。モジュールを使用すると、他の人のコードと一緒に使用される際に名前の衝突を心配することなく、トップレベルの定義を作成できます。詳細については、[モジュールに関するマニュアルのセクション](@ref modules)を参照してください。

# 例

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
