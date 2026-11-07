```julia
LazyLibrary(name; flags = <default dlopen flags>,
            dependencies = LazyLibrary[], on_load_callback = nothing)
```

`ccall()`、`@ccall`、`dlopen()`、`dlsym()`、`dlpath()`、または`cglobal()`で初めて使用されるまで、自身と依存関係の読み込みを遅延する、遅延読み込み型の共有ライブラリを表します。これは、ライブラリを必要に応じて初期化するためのスレッドセーフな仕組みです。

# Arguments

  * `name`: ライブラリ名（または遅延パス計算）。`String`、[`LazyLibraryPath`](@ref)、または[`BundledLazyLibraryPath`](@ref)として指定します。
  * `flags`: 省略可能な`dlopen`フラグ（既定値: `RTLD_LAZY | RTLD_DEEPBIND`）。[`dlopen`](@ref)を参照してください。
  * `dependencies`: このライブラリより先に読み込む`LazyLibrary`オブジェクト参照のベクトル。
  * `on_load_callback`: 初回読み込み時に任意のコードを実行する省略可能な関数（使用は控えめにしてください。`ccall()`によって大量のJuliaコードが実行されることは想定されていません。`on_load_callback`内から`ccall()`を呼び出せるのは、現在のライブラリとその依存関係に限られます。また、デッドロックする可能性があるため、ロード時コールバック内のタスクに対して`wait()`を呼び出してはいけません）。

dlopen操作はスレッドセーフです。ライブラリを読み込むスレッドは1つだけで、各依存関係の読み込み時に、その依存関係への参照がrelease storeされた後に取得されます。読み込みが完了するまで、ほかのタスクはブロックされます。その後、ハンドルはキャッシュされ、以降のすべての呼び出しで再利用されます（遅延読み込みライブラリにはdlcloseがなく、返されたハンドルに対してdlcloseを呼び出してはいけません）。

# Examples

```julia
# Basic usage
const mylib = LazyLibrary("libmylib")
@ccall mylib.myfunc(42::Cint)::Cint

# With dependencies
const libfoo = LazyLibrary("libfoo")
const libbar = LazyLibrary("libbar"; dependencies=[libfoo])
```

プラットフォーム固有のライブラリ、遅延パスの構築、`__init__()`パターンからの移行など、さらに詳しい例については、[Using LazyLibrary for Lazy Loading](@ref man-lazylibrary)のマニュアルセクションを参照してください。

!!! compat "Julia 1.11"
    `LazyLibrary`はJulia 1.11で追加されました。


[`LazyLibraryPath`](@ref)、[`BundledLazyLibraryPath`](@ref)、[`dlopen`](@ref)、[`dlsym`](@ref)、[`add_dependency!`](@ref)も参照してください。
