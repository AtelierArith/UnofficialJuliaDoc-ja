# Documentation

関数、メソッド、型は、定義の前に文字列を置くことでドキュメント化できます。

```julia
"""
    foo(x)

Return a fooified version of `x`.
"""
foo(x) = ...
```

`@doc` マクロを直接使うと、ドキュメントやメタデータの設定と取得の両方を行えます。このマクロには特殊な構文解析機能があり、ドキュメント化するオブジェクトを次の行に記述できます。

```julia
@doc "blah"
function foo() ...
```

デフォルトではドキュメントは Markdown で記述しますが、最初の引数には任意のオブジェクトを指定できます。

## Documenting objects separately from their definitions

オブジェクトの定義の前後どちらでも、次のようにドキュメントを記述できます。

```julia
@doc "foo" function_to_doc
@doc "bar" TypeToDoc
```

マクロの場合、構文は `@doc "macro doc" :(Module.@macro)` です。文字列マクロでは `@doc "macro doc" :(string_macro"")` を使います。クォート `:()` を付けない場合、マクロの展開結果がドキュメント化されます。

## Retrieving Documentation

関数、マクロ、その他のオブジェクトのドキュメントは、次のように取得できます。

```julia
@doc foo
@doc @time
@doc md""
```

!!! compat "Julia 1.11"
    Julia 1.11 以降では、`@doc` マクロでドキュメントを取得するには、`REPL` 標準ライブラリを読み込む必要があります。


## Functions & Methods

メソッド定義（例: `function foo() ...` や `foo() = ...`）の前にドキュメントを置くと、関数全体ではなく、その特定のメソッドがドキュメント化されます。各メソッドのドキュメントは、関数のドキュメントとして提供されるよう、定義された順に連結されます。
