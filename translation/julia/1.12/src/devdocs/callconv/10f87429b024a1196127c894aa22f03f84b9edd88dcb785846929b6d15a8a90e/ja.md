# Calling Conventions

Juliaは4つの異なる目的のために3つの呼び出し規約を使用します：

| Name    | Prefix    | Purpose                          |
|:------- |:--------- |:-------------------------------- |
| Native  | `julia_`  | Speed via specialized signatures |
| JL Call | `jlcall_` | Wrapper for generic calls        |
| JL Call | `jl_`     | Builtins                         |
| C ABI   | `jlcapi_` | Wrapper callable from C          |

## Julia Native Calling Convention

ネイティブコールの規約は、高速な非汎用呼び出しのために設計されています。通常、特化したシグネチャを使用します。

  * LLVMのゴースト（ゼロ長型）は省略されます。
  * LLVMのスカラーとベクターは値渡しされます。
  * LLVMのアグリゲート（配列や構造体）は参照渡しされます。

小さな戻り値はLLVMの戻り値として返されます。大きな戻り値は「構造体戻り」（`sret`）規約を介して返され、呼び出し元が戻りスロットへのポインタを提供します。

引数または戻り値が同種のタプルである場合、LLVM配列の代わりにLLVMベクターとして表現されることがあります。

## JL Call Convention

JLコール規約は、ビルトイン関数と汎用ディスパッチのためのものです。この規約を使用する手書きの関数は、マクロ`JL_CALLABLE`を介して宣言されます。この規約は、正確に3つのパラメータを使用します：

  * `F`  - 適用されている関数のJulia表現
  * `args` - ボックスへのポインタの配列へのポインタ
  * `nargs` - 配列の長さ

戻り値はボックスへのポインタです。

## C ABI

C ABIラッパーは、CからJuliaを呼び出すことを可能にします。ラッパーは、ネイティブ呼び出し規約を使用して関数を呼び出します。

タプルは常にC配列として表現されます。
