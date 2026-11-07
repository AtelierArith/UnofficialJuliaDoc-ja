```julia
escape_exception!(astate::AnalysisState, tryregions::Vector{UnitRange{Int}})
```

`tryregions`で発生し得る例外を介して、エスケープ情報を伝播します。

一見すると、`:the_exception`オブジェクトに課されるエスケープ情報を伝播するだけで十分に思えます。しかし実際には、`Base.current_exceptions`や、`rethrow`nオブジェクトを手動で捕捉するなど、例外オブジェクトにアクセスする方法はほかにもいくつかあります。たとえば、以下の例では、`rethrow_escape!()`呼び出しを介して割り当て済みオブジェクトがエスケープする可能性を、エスケープ解析で考慮する必要があります。

```julia
const Gx = Ref{Any}()
@noinline function rethrow_escape!()
    try
        rethrow()
    catch err
        Gx[] = err
    end
end
unsafeget(x) = isassigned(x) ? x[] : throw(x)

code_escapes() do
    r = Ref{String}()
    try
        t = unsafeget(r)
    catch err
        t = typeof(err)  # `err` (which `r` may alias to) doesn't escape here
        rethrow_escape!() # `r` can escape here
    end
    return t
end
```

上の例が示すように、既存の例外インターフェースを介したあらゆるエスケープの可能性を正しく推論するには、基本的なエスケープ解析に加えてグローバル解析が必要です。現時点では、このような追加解析を行う価値はない可能性があります。例外処理やエラーパスは通常、性能に対する要求がそれほど厳しくなく、また、レイテンシー上の理由から意図的に「最適化されていない」場合もあるため、エラーパスの最適化がほとんど効果をもたらさないこともあります。そのため、保守的に、スローされる可能性のあるすべてのオブジェクトに対して常に`AllEscape`を伝播します。
