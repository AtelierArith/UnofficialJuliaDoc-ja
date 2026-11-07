```julia
abstract type AbstractSpinLock <: AbstractLock end
```

再入不可のテスト・アンド・テスト・アンド・セット方式のスピンロックです。再帰的に使用するとデッドロックが発生します。この種のロックは、実行時間が短く、ブロックしない（たとえば、I/O を行わない）コードの周囲でのみ使用してください。一般には、代わりに [`ReentrantLock`](@ref) を使用してください。

各 [`lock`](@ref) には、対応する [`unlock`](@ref) が必要です。[`!islocked(lck::AbstractSpinLock)`](@ref islocked) が成り立つ場合、ほかのタスクが「同時に」ロックを取得しようとしていなければ、[`trylock(lck)`](@ref trylock) は成功します。

テスト・アンド・テスト・アンド・セット方式のスピンロックが最も高速なのは、競合するスレッドが約 30 個までの場合です。それ以上の競合がある場合は、別の同期方式を検討してください。

!!! compat "Julia 1.13"
    この型を使用するには、Julia 1.13 以降が必要です。

