```julia
@noinline
```

関数をインライン化しないよう、コンパイラーにヒントを与えます。

小さな関数は通常、自動的にインライン化されます。小さな関数に`@noinline`を使用すると、自動インライン化を防げます。

`@noinline`は、関数定義の直前、または関数本体内で使用できます。

```julia
# annotate long-form definition
@noinline function longdef(x)
    ...
end

# annotate short-form definition
@noinline shortdef(x) = ...

# annotate anonymous function that a `do` block creates
f() do
    @noinline
    ...
end
```

!!! compat "Julia 1.8"
    関数本体内での使用には、Julia 1.8以降が必要です。


---

```julia
@noinline block
```

`block`内の呼び出しをインライン化しないよう、コンパイラーにヒントを与えます。

```julia
# The compiler will try to not inline `f`
@noinline f(...)

# The compiler will try to not inline `f`, `g` and `+`
@noinline f(...) + g(...)
```

!!! note
    呼び出し箇所の注釈は、呼び出される関数の定義に適用された注釈よりも常に優先されます。

    ```julia
    @inline function explicit_inline(args...)
        # body
    end

    let
        @noinline explicit_inline(args...) # will not be inlined
    end
    ```


!!! note
    呼び出し箇所の注釈が入れ子になっている場合は、最も内側の注釈が優先されます。

    ```julia
    @inline let a0, b0 = ...
        a = @noinline f(a0)  # the compiler will NOT try to inline this call
        b = f(b0)            # the compiler will try to inline this call
        return a, b
    end
    ```


!!! compat "Julia 1.8"
    呼び出し箇所の注釈には、Julia 1.8以降が必要です。


---

!!! note
    関数が単純な場合（たとえば、定数を返すだけの場合）は、それでもインライン化されることがあります。

