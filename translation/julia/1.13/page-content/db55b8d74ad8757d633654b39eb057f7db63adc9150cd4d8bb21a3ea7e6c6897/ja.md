# [Core.Builtins](@id lib-builtins)

以下の組み込み関数は不安定と見なされていますが、Juliaプログラムの能力や動作を定義する基本的な定義を提供します。通常は、より高水準の汎用APIを通じて利用します。

## Raw access to memory

```@docs
Core.Intrinsics.pointerref
Core.Intrinsics.pointerset
Core.Intrinsics.atomic_pointerref
Core.Intrinsics.atomic_pointerset
Core.Intrinsics.atomic_pointerswap
Core.Intrinsics.atomic_pointermodify
Core.Intrinsics.atomic_pointerreplace
```

## Managed memory

```@docs
Core.memorynew
Core.memoryrefnew
Core.memoryrefoffset
Core.memoryrefget
Core.memoryrefset!
Core.memoryref_isassigned
Core.memoryrefswap!
Core.memoryrefmodify!
Core.memoryrefreplace!
Core.memoryrefsetonce!
```

## Module bindings

```@docs
Core.get_binding_type
```

## Other

```@docs
Core.IntrinsicFunction
Core.Intrinsics
Core.IR
Base.quoted
Base.isa_ast_node
```
