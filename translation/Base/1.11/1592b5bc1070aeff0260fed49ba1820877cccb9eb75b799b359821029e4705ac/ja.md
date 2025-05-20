```
@atomicreplace a.b.x 期待される => 希望する
@atomicreplace :sequentially_consistent a.b.x 期待される => 希望する
@atomicreplace :sequentially_consistent :monotonic a.b.x 期待される => 希望する
```

ペアで表現された条件付き置換を原子的に実行し、値 `(old, success::Bool)` を返します。ここで `success` は置換が完了したかどうかを示します。

この操作は `replaceproperty!(a.b, :x, 期待される, 希望する)` の呼び出しに相当します。

詳細についてはマニュアルの [Per-field atomics](@ref man-atomics) セクションを参照してください。

# 例

```jldoctest
julia> mutable struct Atomic{T}; @atomic x::T; end

julia> a = Atomic(1)
Atomic{Int64}(1)

julia> @atomicreplace a.x 1 => 2 # aのフィールドxを1であれば2に置換し、逐次的整合性を持つ
(old = 1, success = true)

julia> @atomic a.x # aのフィールドxを取得し、逐次的整合性を持つ
2

julia> @atomicreplace a.x 1 => 2 # aのフィールドxを1であれば2に置換し、逐次的整合性を持つ
(old = 2, success = false)

julia> xchg = 2 => 0; # aのフィールドxを2であれば0に置換し、逐次的整合性を持つ

julia> @atomicreplace a.x xchg
(old = 2, success = true)

julia> @atomic a.x # aのフィールドxを取得し、逐次的整合性を持つ
0
```

!!! compat "Julia 1.7"
    この機能は少なくともJulia 1.7が必要です。

