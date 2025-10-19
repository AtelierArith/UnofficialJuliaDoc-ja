```julia
@kwdef typedef
```

これは、`typedef`の式で宣言された型のためにキーワードベースのコンストラクタを自動的に定義するヘルパーマクロです。`typedef`は`struct`または`mutable struct`の式でなければなりません。デフォルト引数は、`field::T = default`または`field = default`の形式でフィールドを宣言することによって提供されます。デフォルトが提供されない場合、キーワード引数は結果の型コンストラクタにおいて必須のキーワード引数となります。

内部コンストラクタはまだ定義できますが、少なくとも1つはデフォルトの内部コンストラクタと同じ形式（すなわち、各フィールドに対して1つの位置引数）で引数を受け入れる必要があります。そうしないと、キーワード外部コンストラクタと正しく機能しません。

!!! compat "Julia 1.1"
    パラメトリック構造体およびスーパタイプを持つ構造体のための`Base.@kwdef`は、少なくともJulia 1.1が必要です。


!!! compat "Julia 1.9"
    このマクロはJulia 1.9以降でエクスポートされます。


# 例

```jldoctest
julia> @kwdef struct Foo
           a::Int = 1         # 指定されたデフォルト
           b::String          # 必須のキーワード
       end
Foo

julia> Foo(b="hi")
Foo(1, "hi")

julia> Foo()
ERROR: UndefKeywordError: keyword argument `b` not assigned
Stacktrace:
[...]
```
