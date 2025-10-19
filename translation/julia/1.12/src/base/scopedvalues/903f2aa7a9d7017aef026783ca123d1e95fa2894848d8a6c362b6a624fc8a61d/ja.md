# [Scoped Values](@id scoped-values)

スコープ付き値は、Juliaにおける動的スコープの実装を提供します。

!!! note "Lexical scoping vs dynamic scoping"
    [Lexical scoping](@ref scope-of-variables) は、Julia におけるデフォルトの動作です。レキシカルスコープでは、変数のスコープはプログラムのレキシカル（テキスト的）構造によって決まります。ダイナミックスコープでは、変数はプログラムの実行中に最も最近割り当てられた値にバインドされます。


スコープ付き値の状態は、プログラムの実行パスに依存しています。これは、スコープ付き値に対して同時に複数の異なる値を観察する可能性があることを意味します。

!!! compat "Julia 1.11"
    スコープ付き値はJulia 1.11で導入されました。Julia 1.8+では、ScopedValues.jlパッケージから互換性のある実装が利用可能です。


その最も単純な形では、デフォルト値を持つ [`ScopedValue`](@ref Base.ScopedValues.ScopedValue) を作成し、その後 [`with`](@ref Base.ScopedValues.with) または [`@with`](@ref Base.ScopedValues.@with) を使用して新しい動的スコープに入ることができます。新しいスコープは、親スコープからすべての値を継承し（外側のすべてのスコープから再帰的に）、提供されたスコープ値が以前の定義よりも優先されます。

まず、**レキシカル**スコープの例を見てみましょう。`let`文は新しいレキシカルスコープを開始し、その中で`x`の外側の定義は内側の定義によって隠されます。

```julia
x = 1
let x = 5
    @show x # 5
end
@show x # 1
```

次の例では、Juliaがレキシカルスコープを使用しているため、`f`の本体内の変数`x`はグローバルスコープで定義された`x`を参照し、`let`スコープに入っても`f`が観察する値は変わりません。

```julia
x = 1
f() = @show x
let x = 5
    f() # 1
end
f() # 1
```

今、`ScopedValue`を使用することで、**動的**スコープを利用できます。

```julia
using Base.ScopedValues

x = ScopedValue(1)
f() = @show x[]
with(x=>5) do
    f() # 5
end
f() # 1
```

`ScopedValue`の観測値は、プログラムの実行経路に依存することに注意してください。

スコープ付き値を指すために `const` 変数を使用することはしばしば理にかなっており、1 回の `with` 呼び出しで複数の `ScopedValue` の値を設定できます。

```julia
using Base.ScopedValues

f() = @show a[]
g() = @show b[]

const a = ScopedValue(1)
const b = ScopedValue(2)

f() # a[] = 1
g() # b[] = 2

# Enter a new dynamic scope and set value.
with(a => 3) do
    f() # a[] = 3
    g() # b[] = 2
    with(a => 4, b => 5) do
        f() # a[] = 4
        g() # b[] = 5
    end
    f() # a[] = 3
    g() # b[] = 2
end

f() # a[] = 1
g() # b[] = 2
```

`ScopedValues`は`with`のマクロバージョンを提供します。式`@with var=>val expr`は、`var`が`val`に設定された新しい動的スコープで`expr`を評価します。`@with var=>val expr`は`with(var=>val) do expr end`と同等です。しかし、`with`はゼロ引数のクロージャまたは関数を必要とし、これが余分なコールフレームを生じさせます。例として、次の関数`f`を考えてみましょう：

```julia
using Base.ScopedValues
const a = ScopedValue(1)
f(x) = a[] + x
```

動的スコープで `a` を `2` に設定して `f` を実行したい場合は、`with` を使用できます:

```julia
with(() -> f(10), a=>2)
```

しかし、これには `f` を引数なしの関数でラップする必要があります。余分なコールフレームを避けたい場合は、`@with` マクロを使用できます：

```julia
@with a=>2 f(10)
```

!!! note
    動的スコープは、タスク作成の瞬間に [`Task`](@ref) に引き継がれます。動的スコープは、**Distributed.jl** 操作を通じて伝播されることはありません。


以下の例では、タスクを開始する前に新しい動的スコープを開きます。親タスクと2つの子タスクは、同じスコープされた値の独立した値を同時に観察します。

```julia
using Base.ScopedValues
import Base.Threads: @spawn

const scoped_val = ScopedValue(1)
@sync begin
    with(scoped_val => 2)
        @spawn @show scoped_val[] # 2
    end
    with(scoped_val => 3)
        @spawn @show scoped_val[] # 3
    end
    @show scoped_val[] # 1
end
```

スコープ付き値はスコープ全体で一定ですが、スコープ付き値に可変状態を格納することができます。ただし、並行プログラミングの文脈では、グローバル変数に関する通常の注意事項が適用されることを忘れないでください。

スコープ付き値に可変状態への参照を保存する際にも注意が必要です。新しい動的スコープに入るときに、明示的に [unshare mutable state](@ref unshare_mutable_state) を行いたいかもしれません。

```julia
using Base.ScopedValues
import Base.Threads: @spawn

const sval_dict = ScopedValue(Dict())

# Example of using a mutable value wrongly
@sync begin
    # `Dict` is not thread-safe the usage below is invalid
    @spawn (sval_dict[][:a] = 3)
    @spawn (sval_dict[][:b] = 3)
end

@sync begin
    # If we instead pass a unique dictionary to each
    # task we can access the dictionaries race free.
    with(sval_dict => Dict()) do
        @spawn (sval_dict[][:a] = 3)
    end
    with(sval_dict => Dict()) do
        @spawn (sval_dict[][:b] = 3)
    end
end
```

## Example

以下の例では、スコープ付き値を使用してウェブアプリケーションでの権限チェックを実装しています。リクエストの権限を決定した後、新しい動的スコープに入り、スコープ付き値 `LEVEL` が設定されます。アプリケーションの他の部分はスコープ付き値を照会でき、適切な値を受け取ります。タスクローカルストレージやグローバル変数のような他の代替手段は、この種の伝播には適していません。私たちの唯一の代替手段は、値をコールチェーン全体にスレッドすることだったでしょう。

```julia
using Base.ScopedValues

const LEVEL = ScopedValue(:GUEST)

function serve(request, response)
    level = isAdmin(request) ? :ADMIN : :GUEST
    with(LEVEL => level) do
        Threads.@spawn handle(request, response)
    end
end

function open(connection::Database)
    level = LEVEL[]
    if level !== :ADMIN
        error("Access disallowed")
    end
    # ... open connection
end

function handle(request, response)
    # ...
    open(Database(#=...=#))
    # ...
end
```

## Idioms

### [Unshare mutable state](@id unshare_mutable_state)

```julia
using Base.ScopedValues
import Base.Threads: @spawn

const sval_dict = ScopedValue(Dict())

# If you want to add new values to the dict, instead of replacing
# it, unshare the values explicitly. In this example we use `merge`
# to unshare the state of the dictionary in parent scope.
@sync begin
    with(sval_dict => merge(sval_dict[], Dict(:a => 10))) do
        @spawn @show sval_dict[][:a]
    end
    @spawn sval_dict[][:a] = 3 # Not a race since they are unshared.
end
```

### Scoped values as globals

スコープ付き値の値にアクセスするには、スコープ付き値自体が（レキシカル）スコープ内に存在する必要があります。これは、ほとんどの場合、スコープ付き値を定数のグローバルとして使用したいことを意味します。

```julia
using Base.ScopedValues
const sval = ScopedValue(1)
```

確かに、スコープ付き値は隠れた関数引数として考えることができます。

これは、彼らの使用が非グローバルであることを妨げるものではありません。

```julia
using Base.ScopedValues
import Base.Threads: @spawn

function main()
    role = ScopedValue(:client)

    function launch()
        #...
        role[]
    end

    @with role => :server @spawn launch()
    launch()
end
```

しかし、これらのケースでは関数の引数を直接渡す方が簡単だったかもしれません。

### Very many ScopedValues

特定のモジュールに対して多くの `ScopedValue` を作成している場合、それらを保持するための専用の構造体を使用する方が良いかもしれません。

```julia
using Base.ScopedValues

Base.@kwdef struct Configuration
    color::Bool = false
    verbose::Bool = false
end

const CONFIG = ScopedValue(Configuration(color=true))

@with CONFIG => Configuration(color=CONFIG[].color, verbose=true) begin
    @show CONFIG[].color # true
    @show CONFIG[].verbose # true
end
```

## API docs

```@docs
Base.ScopedValues.ScopedValue
Base.ScopedValues.with
Base.ScopedValues.@with
Base.isassigned(::Base.ScopedValues.ScopedValue)
Base.ScopedValues.get
```

## Implementation notes and performance

`Scope`は永続的な辞書を使用します。検索と挿入は`O(log(32, n))`であり、動的スコープに入る際に少量のデータがコピーされ、変更されていないデータは他のスコープと共有されます。

`Scope`オブジェクト自体はユーザー向けではなく、将来のJuliaのバージョンで変更される可能性があります。

## Design inspiration

このデザインは、[JEPS-429](https://openjdk.org/jeps/429) に大きく影響を受けており、さらに多くのLisp方言における動的スコープの自由変数に触発されています。特に、Interlisp-Dとその深いバインディング戦略に関してです。

以前に議論されたデザインは、[PEPS-567](https://peps.python.org/pep-0567/) のようなコンテキスト変数であり、Juliaで [ContextVariablesX.jl](https://github.com/tkf/ContextVariablesX.jl) として実装されました。
