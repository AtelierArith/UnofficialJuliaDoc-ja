```julia
@inline
```

この関数をインライン化する価値があることを、コンパイラーにヒントとして伝えます。

小さな関数には通常、`@inline`注釈は必要ありません。コンパイラーが自動的にインライン化するためです。大きな関数に`@inline`を使うと、インライン化するようコンパイラーにさらに促すことができます。

`@inline`は、関数定義の直前、または関数本体内に適用できます。

```julia
# annotate long-form definition
@inline function longdef(x)
    ...
end

# annotate short-form definition
@inline shortdef(x) = ...

# annotate anonymous function that a `do` block creates
f() do
    @inline
    ...
end
```

!!! compat "Julia 1.8"
    関数本体内での使用には、Julia 1.8以降が必要です。


---

```julia
@inline block
```

`block`内の呼び出しをインライン化する価値があることを、コンパイラーにヒントとして伝えます。

```julia
# The compiler will try to inline `f`
@inline f(...)

# The compiler will try to inline `f`, `g` and `+`
@inline f(...) + g(...)
```

!!! note
    呼び出し箇所の注釈は、呼び出される関数の定義に適用された注釈よりも常に優先されます。

    ```julia
    @noinline function explicit_noinline(args...)
        # body
    end

    let
        @inline explicit_noinline(args...) # will be inlined
    end
    ```


!!! note
    呼び出し箇所の注釈は、そのブロック内のすべての呼び出しに適用されます。呼び出し自体が関数の引数になっている場合も含みます。

    ```julia
    # The compiler will not inline `getproperty`, `g` or `f`
    @noinline f(x.inner, g(y))
    ```


!!! note
    呼び出し箇所の注釈が入れ子になっている場合は、最も内側の注釈が優先されます。

    ```julia
    @noinline let a0, b0 = ...
        a = @inline f(a0)  # the compiler will try to inline this call
        b = f(b0)          # the compiler will NOT try to inline this call
        return a, b
    end
    ```


!!! warning
    呼び出し箇所の注釈は、コストモデルにかかわらずインライン化を強制しようとしますが、成功しない場合もあります。特に、再帰呼び出しは`@inline`dとして注釈されていても、インライン化できません。


!!! compat "Julia 1.8"
    呼び出し箇所の注釈には、Julia 1.8以降が必要です。

