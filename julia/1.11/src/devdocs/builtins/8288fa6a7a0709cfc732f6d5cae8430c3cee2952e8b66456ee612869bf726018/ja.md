# [Core.Builtins](@id lib-builtins)

## Builtin Function APIs

次のビルトイン関数APIは不安定と見なされていますが、Juliaプログラムの能力と動作を定義する基本的な定義を提供します。これらは通常、より高レベルの汎用APIを通じてアクセスされます。

```@docs
Core.memoryrefnew
Core.memoryrefoffset
Core.memoryrefget
Core.memoryrefset!
Core.memoryref_isassigned
Core.memoryrefswap!
Core.memoryrefmodify!
Core.memoryrefreplace!
Core.memoryrefsetonce!
Core.Intrinsics.atomic_pointerref
Core.Intrinsics.atomic_pointerset
Core.Intrinsics.atomic_pointerswap
Core.Intrinsics.atomic_pointermodify
Core.Intrinsics.atomic_pointerreplace
Core.get_binding_type
Core.set_binding_type!
Core.IntrinsicFunction
Core.Intrinsics
Core.IR
```
