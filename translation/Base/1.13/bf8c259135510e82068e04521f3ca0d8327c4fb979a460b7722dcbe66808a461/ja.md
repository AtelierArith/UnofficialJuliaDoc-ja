```julia
@kwdef typedef
```

これは、式 `typedef` で宣言された型に対して、キーワード引数を使うコンストラクターを自動的に定義するヘルパーマクロです。この式は `struct` または `mutable struct` でなければなりません。デフォルト引数は、`field::T = default` または `field = default` の形式でフィールドを宣言することで指定します。デフォルト値を指定しない場合、生成される型コンストラクターでは、そのキーワード引数は必須になります。

内部コンストラクターも定義できますが、キーワード引数を使う外部コンストラクターが正しく機能するには、少なくとも1つの内部コンストラクターがデフォルトの内部コンストラクターと同じ形式の引数（つまり、フィールドごとに1つの位置引数）を受け取る必要があります。

!!! compat "Julia 1.1"
    パラメトリック構造体およびスーパータイプを持つ構造体に対する `Base.@kwdef` の使用には、Julia 1.1 以降が必要です。


!!! compat "Julia 1.9"
    このマクロは Julia 1.9 以降でエクスポートされています。


# Examples

```jldoctest
julia> @kwdef struct Foo
           a::Int = 1         # specified default
           b::String          # required keyword
       end
Foo

julia> Foo(b="hi")
Foo(1, "hi")

julia> Foo()
ERROR: UndefKeywordError: keyword argument `b` not assigned
Stacktrace:
[...]
```
