```
@atomic var
@atomic order ex
```

`var` または `ex` を原子的に実行されるものとしてマークします。`order` が指定されていない場合、デフォルトは :sequentially_consistent です。

```
@atomic a.b.x = new
@atomic a.b.x += addend
@atomic :release a.b.x = new
@atomic :acquire_release a.b.x += addend
```

右側で表現されたストア操作を原子的に実行し、新しい値を返します。

`=` を使用する場合、この操作は `setproperty!(a.b, :x, new)` 呼び出しに変換されます。演算子を使用する場合も、この操作は `modifyproperty!(a.b, :x, +, addend)[2]` 呼び出しに変換されます。

```
@atomic a.b.x max arg2
@atomic a.b.x + arg2
@atomic max(a.b.x, arg2)
@atomic :acquire_release max(a.b.x, arg2)
@atomic :acquire_release a.b.x + arg2
@atomic :acquire_release a.b.x max arg2
```

右側で表現された二項操作を原子的に実行します。結果を最初の引数のフィールドに格納し、値 `(old, new)` を返します。

この操作は `modifyproperty!(a.b, :x, func, arg2)` 呼び出しに変換されます。

詳細については、マニュアルの [Per-field atomics](@ref) セクションを参照してください。

# 例

```jldoctest
julia> mutable struct Atomic{T}; @atomic x::T; end

julia> a = Atomic(1)
Atomic{Int64}(1)

julia> @atomic a.x # a のフィールド x を取得し、順序の一貫性を持つ
1

julia> @atomic :sequentially_consistent a.x = 2 # a のフィールド x を設定し、順序の一貫性を持つ
2

julia> @atomic a.x += 1 # a のフィールド x をインクリメントし、順序の一貫性を持つ
3

julia> @atomic a.x + 1 # a のフィールド x をインクリメントし、順序の一貫性を持つ
3 => 4

julia> @atomic a.x # a のフィールド x を取得し、順序の一貫性を持つ
4

julia> @atomic max(a.x, 10) # a のフィールド x を最大値に変更し、順序の一貫性を持つ
4 => 10

julia> @atomic a.x max 5 # 再度 a のフィールド x を最大値に変更し、順序の一貫性を持つ
10 => 10
```

!!! compat "Julia 1.7"
    この機能は少なくとも Julia 1.7 が必要です。

