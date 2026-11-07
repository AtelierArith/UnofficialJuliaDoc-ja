```julia
@deprecate old new [export_old=true]
```

メソッド `old` を非推奨にし、置き換え後の呼び出し `new` を指定します。その際、指定されたシグネチャを持つ新しいメソッド `old` を定義します。

`old` がエクスポートされないようにするには、`export_old` を `false` に設定します。

関連項目: [`Base.depwarn()`](@ref)。

!!! compat "Julia 1.5"
    Julia 1.5 以降では、`@deprecate` で定義された関数は、`--depwarn=yes` フラグを設定せずに `julia` を実行しても警告を出力しません。これは、`--depwarn` オプションのデフォルト値が `no` であるためです。警告は、`Pkg.test()` が実行するテストから出力されます。


# Examples

```jldoctest
julia> @deprecate old_export(x) new(x)
old_export (generic function with 1 method)

julia> @deprecate old_public(x) new(x) false
old_public (generic function with 1 method)
```

型注釈を明示せずに `@deprecate` を呼び出すと、任意の数の位置引数とキーワード引数を受け取る、型 `Any` の非推奨メソッドが定義されます。

!!! compat "Julia 1.9"
    Julia 1.9 以降では、型注釈を明示しない場合、キーワード引数も転送されます。それ以前のバージョンでは、`@deprecate old(args...; kwargs...) new(args...; kwargs...)` のようにして、位置引数とキーワード引数を手動で転送できます。


非推奨化を特定のシグネチャに限定するには、`old` の引数に型注釈を付けます。たとえば、

```jldoctest; filter = r"@ .*"a
julia> new(x::Int) = x;

julia> new(x::Float64) = 2x;

julia> @deprecate old(x::Int) new(x);

julia> methods(old)
# 1 method for generic function "old" from Main:
 [1] old(x::Int64)
     @ deprecated.jl:94
```

これにより、`new(x::Int)` と同じ動作をするメソッド `old(x::Int)` が定義され、非推奨になります。一方、メソッド `old(x::Float64)` は定義も非推奨化もされません。
