```julia
@deprecate old new [export_old=true]
```

メソッド `old` を非推奨にし、置き換え呼び出し `new` を指定し、その過程で指定されたシグネチャの新しいメソッド `old` を定義します。

`old` がエクスポートされないようにするには、`export_old` を `false` に設定します。

[`Base.depwarn()`](@ref) も参照してください。

!!! compat "Julia 1.5"
    Julia 1.5 以降、`@deprecate` によって定義された関数は、`--depwarn=yes` フラグが設定されていない場合に警告を表示しません。デフォルトの `--depwarn` オプションの値は `no` です。警告は `Pkg.test()` によって実行されるテストから表示されます。


# 例

```jldoctest
julia> @deprecate old_export(x) new(x)
old_export (generic function with 1 method)

julia> @deprecate old_public(x) new(x) false
old_public (generic function with 1 method)
```

明示的な型アノテーションなしでの `@deprecate` への呼び出しは、任意の数の位置引数およびキーワード引数を `Any` 型で受け入れる非推奨メソッドを定義します。

!!! compat "Julia 1.9"
    明示的な型アノテーションがない場合、キーワード引数は Julia 1.9 以降に転送されます。古いバージョンでは、`@deprecate old(args...; kwargs...) new(args...; kwargs...)` を行うことで、位置引数とキーワード引数を手動で転送できます。


特定のシグネチャに非推奨を制限するには、`old` の引数にアノテーションを付けます。例えば、

```jldoctest; filter = r"@ .*"a
julia> new(x::Int) = x;

julia> new(x::Float64) = 2x;

julia> @deprecate old(x::Int) new(x);

julia> methods(old)
# 1 method for generic function "old" from Main:
 [1] old(x::Int64)
     @ deprecated.jl:94
```

は、`new(x::Int)` を反映する `old(x::Int)` というメソッドを定義し非推奨にしますが、`old(x::Float64)` というメソッドは定義せず、非推奨にもなりません。
