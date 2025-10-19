```julia
invoke(f, argtypes::Type, args...; kwargs...)
invoke(f, argtypes::Method, args...; kwargs...)
invoke(f, argtypes::CodeInstance, args...; kwargs...)
```

指定された引数 `args` に対して、指定された型 `argtypes` に一致する与えられた汎用関数 `f` のメソッドを呼び出します。引数 `args` は、指定された型 `argtypes` に準拠している必要があり、すなわち自動的な変換は行われません。このメソッドは、最も特異的な一致メソッド以外のメソッドを呼び出すことを可能にし、より一般的な定義の動作が明示的に必要な場合に便利です（しばしば同じ関数のより特異的なメソッドの実装の一部として）。ただし、これはランタイムがより多くの作業を行う必要があることを意味するため、`invoke` は通常の呼び出しによる通常のディスパッチよりも遅くなることが一般的です—時にはかなり遅くなることもあります。

自分が書いていない関数に対して `invoke` を使用する際は注意が必要です。与えられた `argtypes` に対してどの定義が使用されるかは、関数が特定の `argtypes` での呼び出しが公開APIの一部であると明示的に述べていない限り、実装の詳細です。例えば、以下の例での `f1` と `f2` の間の変更は、通常の（非 `invoke`）呼び出しで呼び出し元からは見えないため、互換性があると見なされます。しかし、`invoke` を使用すると変更が見えます。

# シグネチャの代わりに `Method` を渡す

`argtypes` 引数は `Method` である場合があり、その場合は通常のメソッドテーブルの検索が完全にバイパスされ、与えられたメソッドが直接呼び出されます。この機能が必要なことは稀です。特に、指定された `Method` が通常のディスパッチ（または通常の `invoke`）から完全に到達不可能である場合、例えば、より特異的なメソッドによって置き換えられたり完全にカバーされたりしている場合に注意してください。メソッドが通常のメソッドテーブルの一部である場合、この呼び出しは `invoke(f, method.sig, args...)` に似た動作をします。

!!! compat "Julia 1.12"
    `Method` を渡すには Julia 1.12 が必要です。


# シグネチャの代わりに `CodeInstance` を渡す

`argtypes` 引数は `CodeInstance` である場合があり、メソッドの検索と特化の両方をバイパスします。この呼び出しの意味は、`CodeInstance` の `invoke` ポインタの関数ポインタ呼び出しに似ています。引数がその親 `MethodInstance` に一致しない場合や、`min_world`/`max_world` 範囲に含まれないワールドエイジから `CodeInstance` を呼び出すことはエラーです。フィールドに指定された制約に一致しない動作を持つ `CodeInstance` を呼び出すことは未定義の動作です。`owner !== nothing` のコードインスタンス（すなわち、外部コンパイラによって生成されたもの）に対しては、プリコンパイルを通過した後に呼び出すことがエラーになる場合があります。これは外部コンパイラプラグインと共に使用するための高度なインターフェースです。

!!! compat "Julia 1.12"
    `CodeInstance` を渡すには Julia 1.12 が必要です。


# 例

```jldoctest
julia> f(x::Real) = x^2;

julia> f(x::Integer) = 1 + invoke(f, Tuple{Real}, x);

julia> f(2)
5

julia> f1(::Integer) = Integer
       f1(::Real) = Real;

julia> f2(x::Real) = _f2(x)
       _f2(::Integer) = Integer
       _f2(_) = Real;

julia> f1(1)
Integer

julia> f2(1)
Integer

julia> invoke(f1, Tuple{Real}, 1)
Real

julia> invoke(f2, Tuple{Real}, 1)
Integer
```
