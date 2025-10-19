```julia
@noinline
```

コンパイラに関数をインライン化しないようにヒントを与えます。

小さな関数は通常自動的にインライン化されます。小さな関数に `@noinline` を使用することで、自動インライン化を防ぐことができます。

`@noinline` は関数定義の直前または関数本体内で適用できます。

```julia
# 長い定義に注釈を付ける
@noinline function longdef(x)
    ...
end

# 短い定義に注釈を付ける
@noinline shortdef(x) = ...

# `do` ブロックが作成する無名関数に注釈を付ける
f() do
    @noinline
    ...
end
```

!!! compat "Julia 1.8"
    関数本体内での使用は少なくとも Julia 1.8 が必要です。


---

```julia
@noinline block
```

コンパイラに `block` 内の呼び出しをインライン化しないようにヒントを与えます。

```julia
# コンパイラは `f` をインライン化しないように試みます
@noinline f(...)

# コンパイラは `f`、`g` および `+` をインライン化しないように試みます
@noinline f(...) + g(...)
```

!!! note
    呼び出しサイトの注釈は、呼び出された関数の定義に適用された注釈よりも常に優先されます：

    ```julia
    @inline function explicit_inline(args...)
        # 本体
    end

    let
        @noinline explicit_inline(args...) # インライン化されません
    end
    ```


!!! note
    ネストされた呼び出しサイトの注釈がある場合、最も内側の注釈が優先されます：

    ```julia
    @inline let a0, b0 = ...
        a = @noinline f(a0)  # コンパイラはこの呼び出しをインライン化しようとしません
        b = f(b0)            # コンパイラはこの呼び出しをインライン化しようとします
        return a, b
    end
    ```


!!! compat "Julia 1.8"
    呼び出しサイトの注釈は少なくとも Julia 1.8 が必要です。


---

!!! note
    関数が単純（例えば定数を返す）である場合、インライン化される可能性があります。

