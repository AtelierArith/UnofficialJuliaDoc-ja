```julia
invoke(f, argtypes::Type, args...; kwargs...)
invoke(f, argtypes::Method, args...; kwargs...)
invoke(f, argtypes::CodeInstance, args...; kwargs...)
```

指定した引数 `args` に対し、指定した型 `argtypes` に一致する、汎用関数 `f` のメソッドを、キーワード引数 `kwargs` を渡して呼び出します。引数 `args` は、指定した型 `argtypes` に適合している必要があります。つまり、自動的な変換は行われません。このメソッドを使うと、最も具体的に一致するメソッド以外のメソッドを呼び出せます。これは、より一般的な定義の動作を明示的に必要とする場合（多くの場合、同じ関数のより具体的なメソッドの実装の一部として）に便利です。ただし、実行時により多くの処理が必要になるため、`invoke` は通常の呼び出しによる通常のディスパッチよりも一般に遅く、場合によっては大幅に遅くなります。

自分で実装していない関数に対して `invoke` を使う場合は注意してください。指定した `argtypes` にどの定義が使われるかは、その関数が特定の `argtypes` での呼び出しを公開 API の一部として明示していない限り、実装の詳細です。たとえば、以下の例における `f1` から `f2` への変更は、通常は互換性があると見なされます。通常の（`invoke` ではない）呼び出しでは、呼び出し側からその変更が見えないためです。しかし、`invoke` を使うと、この変更は見えるようになります。

# Passing a `Method` instead of a signature

`argtypes` 引数には `Method` を指定できます。その場合、通常のメソッドテーブル検索は完全に省略され、指定したメソッドが直接呼び出されます。この機能が必要になることはまれです。特に、指定した `Method` は、より具体的なメソッドに置き換えられている、または完全に覆われているなどの理由で、通常のディスパッチ（または通常の invoke）では到達できない場合があります。そのメソッドが通常のメソッドテーブルに含まれている場合、この呼び出しの動作は `invoke(f, method.sig, args...)` と同様です。

!!! compat "Julia 1.12"
    `Method` を渡すには Julia 1.12 が必要です。


# Passing a `CodeInstance` instead of a signature

`argtypes` 引数には `CodeInstance` を指定できます。この場合、メソッド検索と特殊化の両方が省略されます。この呼び出しの意味は、`CodeInstance` の `invoke` ポインターを関数ポインターとして呼び出す場合と同様です。`CodeInstance` を、その親である `MethodInstance` に一致しない引数で呼び出した場合、または `min_world`/`max_world` の範囲に含まれないワールドエイジから呼び出した場合は、エラーになります。フィールドで指定された制約に動作が適合しない `CodeInstance` を呼び出した場合の動作は未定義です。`owner !== nothing` を持つ一部のコードインスタンス（外部コンパイラーが生成したものなど）は、プリコンパイルを経た後に呼び出すとエラーになる場合があります。これは、外部コンパイラープラグインでの使用を想定した高度なインターフェースです。

!!! compat "Julia 1.12"
    `CodeInstance` を渡すには Julia 1.12 が必要です。


# Examples

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
