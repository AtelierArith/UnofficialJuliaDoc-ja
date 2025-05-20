```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/Random/docs/src/index.md"
```

# Random Numbers

```@meta
DocTestSetup = :(using Random)
```

Juliaにおける乱数生成は、デフォルトで[Xoshiro256++](https://prng.di.unimi.it/)アルゴリズムを使用し、`Task`ごとに状態を持ちます。他のRNGタイプは`AbstractRNG`タイプを継承することでプラグインでき、これにより複数の乱数ストリームを取得することができます。

`Random`パッケージによってエクスポートされるPRNG（擬似乱数生成器）は次のとおりです：

  * `TaskLocalRNG`: 現在アクティブなタスクローカルストリームの使用を表すトークンで、親タスクから決定論的にシードされるか、プログラム開始時に `RandomDevice`（システムのランダム性を使用）によってシードされます。
  * `Xoshiro`: Xoshiro256++アルゴリズムを使用して、小さな状態ベクトルと高いパフォーマンスで高品質の乱数ストリームを生成します。
  * `RandomDevice`: OS提供のエントロピー。これは暗号的に安全な乱数（CS(P)RNG）に使用される場合があります。
  * `MersenneTwister`: 古いバージョンのJuliaでデフォルトだった代替の高品質なPRNGで、非常に高速ですが、状態ベクトルを保存しランダムシーケンスを生成するためにはるかに多くのスペースを必要とします。

ほとんどのランダム生成に関連する関数は、最初の引数としてオプションの `AbstractRNG` オブジェクトを受け入れます。また、ランダム値の配列を生成するために、次元指定 `dims...`（タプルとしても指定可能）を受け入れるものもあります。マルチスレッドプログラムでは、一般的に異なるスレッドやタスクから異なるRNGオブジェクトを使用してスレッドセーフを確保するべきです。ただし、デフォルトのRNGはJulia 1.3以降スレッドセーフであり（バージョン1.6まではスレッドごとのRNGを使用し、それ以降はタスクごとに使用します）。

提供されたRNGは、以下のタイプの一様乱数を生成できます： [`Float16`](@ref)、 [`Float32`](@ref)、 [`Float64`](@ref)、 [`BigFloat`](@ref)、 [`Bool`](@ref)、 [`Int8`](@ref)、 [`UInt8`](@ref)、 [`Int16`](@ref)、 [`UInt16`](@ref)、 [`Int32`](@ref)、 [`UInt32`](@ref)、 [`Int64`](@ref)、 [`UInt64`](@ref)、 [`Int128`](@ref)、 [`UInt128`](@ref)、 [`BigInt`](@ref)（またはそれらのタイプの複素数）。ランダムな浮動小数点数は $[0, 1)$ の範囲で一様に生成されます。 `BigInt` は無制限の整数を表すため、区間を指定する必要があります（例： `rand(big.(1:6))`）。

さらに、通常分布と指数分布は一部の `AbstractFloat` および `Complex` タイプに実装されています。詳細については [`randn`](@ref) および [`randexp`](@ref) を参照してください。

他の分布からランダムな数を生成するには、[Distributions.jl](https://juliastats.org/Distributions.jl/stable/)パッケージを参照してください。

!!! warning
    ランダム数が生成される正確な方法は実装の詳細と見なされるため、バグ修正や速度改善により、バージョン変更後に生成される数のストリームが変わる可能性があります。ユニットテスト中に特定のシードや生成された数のストリームに依存することは推奨されません - 代わりに、問題のメソッドの特性をテストすることを検討してください。


## Random numbers module

```@docs
Random.Random
```

## Random generation functions

```@docs
Random.rand
Random.rand!
Random.bitrand
Random.randn
Random.randn!
Random.randexp
Random.randexp!
Random.randstring
```

## Subsequences, permutations and shuffling

```@docs
Random.randsubseq
Random.randsubseq!
Random.randperm
Random.randperm!
Random.randcycle
Random.randcycle!
Random.shuffle
Random.shuffle!
```

## Generators (creation and seeding)

```@docs
Random.default_rng
Random.seed!
Random.AbstractRNG
Random.TaskLocalRNG
Random.Xoshiro
Random.MersenneTwister
Random.RandomDevice
```

## [Hooking into the `Random` API](@id rand-api-hook)

`Random` 機能を拡張する主に直交する2つの方法があります：

1. カスタムタイプのランダム値を生成する
2. 新しいジェネレーターの作成

The API for 1) is quite functional, but is relatively recent so it may still have to evolve in subsequent releases of the `Random` module. For example, it's typically sufficient to implement one `rand` method in order to have all other usual methods work automatically.

The API for 2) is still rudimentary, and may require more work than strictly necessary from the implementor, in order to support usual types of generated values.

### Generating random values of custom types

ランダム値を生成するためのいくつかの分布には、さまざまなトレードオフが関与する場合があります。*事前計算された* 値、例えば離散分布のための [alias table](https://en.wikipedia.org/wiki/Alias_method) や、単変量分布のための [“squeezing” functions](https://en.wikipedia.org/wiki/Rejection_sampling) は、サンプリングを大幅に高速化することができます。事前に計算すべき情報の量は、分布から引き出す予定の値の数によって異なる場合があります。また、いくつかの乱数生成器には、さまざまなアルゴリズムが利用したい特定の特性がある場合があります。

`Random` モジュールは、これらの問題に対処するためのランダム値を取得するためのカスタマイズ可能なフレームワークを定義しています。 `rand` の各呼び出しは、上記のトレードオフを考慮してカスタマイズできる *サンプラー* を生成します。これは、`Sampler` にメソッドを追加することで実現され、ランダム数生成器、分布を特徴づけるオブジェクト、および繰り返し回数の提案に基づいてディスパッチできます。現在、後者については、`Val{1}`（単一サンプル用）と `Val{Inf}`（任意の数用）が使用されており、`Random.Repetition` は両者のエイリアスです。

`Sampler`によって返されるオブジェクトは、ランダムな値を生成するために使用されます。サンプリング可能な値`X`のためのランダム生成インターフェースを実装する際、実装者は次のメソッドを定義する必要があります。

```julia
rand(rng, sampler)
```

`Sampler(rng, X, repetition)`によって返される特定の`sampler`について。

サンプラーは `rand(rng, sampler)` を実装する任意の値であることができますが、ほとんどのアプリケーションでは以下の定義済みサンプラーで十分かもしれません：

1. `SamplerType{T}()` は、型 `T` からサンプリングを行うサンプラーを実装するために使用できます（例： `rand(Int)`）。これは、*型* に対して `Sampler` が返すデフォルトです。
2. `SamplerTrivial(self)`は、`self`のシンプルなラッパーであり、`[]`でアクセスできます。これは、事前に計算された情報が必要ない場合（例：`rand(1:3)`）に推奨されるサンプラーであり、*values*のために`Sampler`によって返されるデフォルトです。
3. `SamplerSimple(self, data)` は、任意の事前計算された値を格納するために使用できる追加の `data` フィールドも含まれており、これは `Sampler` の *カスタムメソッド* で計算されるべきです。

これらの各例を提供します。ここでは、アルゴリズムの選択がRNGとは独立していると仮定し、署名には`AbstractRNG`を使用します。

```@docs
Random.Sampler
Random.SamplerType
Random.SamplerTrivial
Random.SamplerSimple
```

事前計算を実際に値を生成することから切り離すことはAPIの一部であり、ユーザーにも利用可能です。例えば、`rand(rng, 1:20)`をループ内で繰り返し呼び出す必要があると仮定します。この切り離しを活用する方法は次のとおりです：

```julia
rng = Xoshiro()
sp = Random.Sampler(rng, 1:20) # or Random.Sampler(Xoshiro, 1:20)
for x in X
    n = rand(rng, sp) # similar to n = rand(rng, 1:20)
    # use n
end
```

これは、標準ライブラリでも使用されるメカニズムであり、例えば、デフォルトの配列生成の実装（`rand(1:20, 10)`のような）によって使用されます。

#### Generating values from a type

与えられた型 `T` に対して、`rand(T)` が定義されている場合、型 `T` のオブジェクトが生成されると仮定されています。`SamplerType` は *型のデフォルトサンプラー* です。型 `T` の値のランダム生成を定義するために、`rand(rng::AbstractRNG, ::Random.SamplerType{T})` メソッドを定義する必要があり、これは `rand(rng, T)` が返すことが期待される値を返すべきです。

次の例を考えてみましょう：`Die`タイプを実装し、1から`n`までの番号が付けられた可変数`n`の面を持つサイコロです。`rand(Die)`が4以上で最大20の面を持つサイコロを生成することを望みます。

```jldoctest Die
struct Die
    nsides::Int # number of sides
end

Random.rand(rng::AbstractRNG, ::Random.SamplerType{Die}) = Die(rand(rng, 4:20))

# output

```

`Die`のスカラーおよび配列メソッドは、期待通りに動作します：

```jldoctest Die; setup = :(Random.seed!(1))
julia> rand(Die)
Die(5)

julia> rand(Xoshiro(0), Die)
Die(10)

julia> rand(Die, 3)
3-element Vector{Die}:
 Die(9)
 Die(15)
 Die(14)

julia> a = Vector{Die}(undef, 3); rand!(a)
3-element Vector{Die}:
 Die(19)
 Die(7)
 Die(17)
```

#### A simple sampler without pre-computed data

ここでは、コレクションのサンプラーを定義します。事前に計算されたデータが必要ない場合、`SamplerTrivial` サンプラーを使用して実装できます。これは実際には *値のデフォルトフォールバック* です。

オブジェクトの型 `S` からのランダム生成を定義するために、次のメソッドを定義する必要があります: `rand(rng::AbstractRNG, sp::Random.SamplerTrivial{S})`。ここで、`sp` は単に型 `S` のオブジェクトをラップしており、`sp[]` を介してアクセスできます。`Die` の例を続けると、`rand(d::Die)` を定義して、`d` の面のいずれかに対応する `Int` を生成したいと思います:

```jldoctest Die; setup = :(Random.seed!(1))
julia> Random.rand(rng::AbstractRNG, d::Random.SamplerTrivial{Die}) = rand(rng, 1:d[].nsides);

julia> rand(Die(4))
1

julia> rand(Die(4), 3)
3-element Vector{Any}:
 2
 3
 3
```

コレクションタイプ `S` が与えられた場合、`rand(::S)` が定義されているなら、`eltype(S)` の型のオブジェクトが生成されると現在仮定されています。最後の例では、`Vector{Any}` が生成されました。その理由は `eltype(Die) == Any` だからです。解決策は `Base.eltype(::Type{Die}) = Int` を定義することです。

#### Generating values for an `AbstractFloat` type

`AbstractFloat` 型は特別扱いされます。なぜなら、デフォルトではランダムな値は全ての型ドメインで生成されるのではなく、むしろ `[0,1)` の範囲で生成されるからです。次のメソッドは `T <: AbstractFloat` に対して実装されるべきです: `Random.rand(::AbstractRNG, ::Random.SamplerTrivial{Random.CloseOpen01{T}})`

#### An optimized sampler with pre-computed data

離散分布を考えます。ここで、数値 `1:n` が与えられた確率で引かれ、その合計が1になります。この分布から多くの値が必要な場合、最も速い方法は [alias table](https://en.wikipedia.org/wiki/Alias_method) を使用することです。このテーブルを構築するためのアルゴリズムはここでは提供しませんが、代わりに `make_alias_table(probabilities)` で利用可能であり、`draw_number(rng, alias_table)` を使用してそこからランダムな数を引くことができます。

分布が次のように記述されていると仮定します。

```julia
struct DiscreteDistribution{V <: AbstractVector}
    probabilities::V
end
```

そして、必要な値の数に関係なく、*常に*エイリアステーブルを構築したいと考えています（この下でカスタマイズする方法を学びます）。メソッド

```julia
Random.eltype(::Type{<:DiscreteDistribution}) = Int

function Random.Sampler(::Type{<:AbstractRNG}, distribution::DiscreteDistribution, ::Repetition)
    SamplerSimple(distribution, make_alias_table(distribution.probabilities))
end
```

サンプラーを事前に計算されたデータで返すように定義されるべきです、その後

```julia
function rand(rng::AbstractRNG, sp::SamplerSimple{<:DiscreteDistribution})
    draw_number(rng, sp.data)
end
```

値を描画するために使用されます。

#### Custom sampler types

`SamplerSimple` 型は、事前に計算されたデータを使用するほとんどのユースケースに対して十分です。しかし、カスタムサンプラータイプの使用方法を示すために、ここでは `SamplerSimple` に似たものを実装します。

私たちの `Die` の例に戻ると、`rand(::Die)` は範囲からのランダム生成を使用するため、この最適化の機会があります。私たちはカスタムサンプラーを `SamplerDie` と呼びます。

```julia
import Random: Sampler, rand

struct SamplerDie <: Sampler{Int} # generates values of type Int
    die::Die
    sp::Sampler{Int} # this is an abstract type, so this could be improved
end

Sampler(RNG::Type{<:AbstractRNG}, die::Die, r::Random.Repetition) =
    SamplerDie(die, Sampler(RNG, 1:die.nsides, r))
# the `r` parameter will be explained later on

rand(rng::AbstractRNG, sp::SamplerDie) = rand(rng, sp.sp)
```

`sp = Sampler(rng, die)`を使ってサンプラーを取得し、`rng`に関わる任意の`rand`呼び出しで`die`の代わりに`sp`を使用することが可能になりました。上記の単純な例では、`die`を`SamplerDie`に保存する必要はありませんが、実際にはこれがよくあるケースです。

もちろん、このパターンは非常に頻繁であるため、上記で使用したヘルパータイプ、つまり `Random.SamplerSimple` が利用可能であり、`SamplerDie` の定義を省略できます。私たちは次のようにデカップリングを実装することができました：

```julia
Sampler(RNG::Type{<:AbstractRNG}, die::Die, r::Random.Repetition) =
    SamplerSimple(die, Sampler(RNG, 1:die.nsides, r))

rand(rng::AbstractRNG, sp::SamplerSimple{Die}) = rand(rng, sp.data)
```

ここで、`sp.data`は`SamplerSimple`コンストラクタへの呼び出しの第二引数を指します（この場合、`Sampler(rng, 1:die.nsides, r)`に等しいです）。一方、`Die`オブジェクトは`sp[]`を介してアクセスできます。

`SamplerDie`のように、カスタムサンプラーはすべて`Sampler{T}`のサブタイプでなければなりません。ここで、`T`は生成される値の型です。`SamplerSimple(x, data) isa Sampler{eltype(x)}`であることに注意してください。これにより、`SamplerSimple`の最初の引数が何であるべきかが制約されます（`x`が単に転送される`Sampler`メソッドを定義する際に、`Die`の例のように`SamplerSimple`を使用することをお勧めします）。同様に、`SamplerTrivial(x) isa Sampler{eltype(x)}`です。

別のヘルパータイプが他のケース用に現在利用可能であり、`Random.SamplerTag`ですが、これは内部APIと見なされており、適切な非推奨なしにいつでも壊れる可能性があります。

#### Using distinct algorithms for scalar or array generation

場合によっては、少数の値を生成したいのか、大量の値を生成したいのかがアルゴリズムの選択に影響を与えることがあります。これは `Sampler` コンストラクタの第3引数で処理されます。少数のランダム値を生成するために使用される `SamplerDie1` と、多くの値のための `SamplerDieMany` という2つのヘルパータイプを定義したと仮定しましょう。これらのタイプは次のように使用できます。

```julia
Sampler(RNG::Type{<:AbstractRNG}, die::Die, ::Val{1}) = SamplerDie1(...)
Sampler(RNG::Type{<:AbstractRNG}, die::Die, ::Val{Inf}) = SamplerDieMany(...)
```

もちろん、`rand`はこれらの型でも定義されている必要があります（すなわち、`rand(::AbstractRNG, ::SamplerDie1)`および`rand(::AbstractRNG, ::SamplerDieMany)`）。通常通り、カスタム型が必要ない場合は、`SamplerTrivial`および`SamplerSimple`を使用できます。

注意: `Sampler(rng, x)` は単に `Sampler(rng, x, Val(Inf))` の省略形であり、`Random.Repetition` は `Union{Val{1}, Val{Inf}}` のエイリアスです。

### Creating new generators

APIはまだ明確に定義されていませんが、一般的な指針として：

1. 任意の `rand` メソッドは、この特定のRNGのために定義されるべきであり、"基本的な" 型（`isbitstype` 整数および浮動小数点型）を生成する場合に必要です;
2. 他の文書化された `rand` メソッドは、`AbstractRNG` を受け入れる場合、（1）で依存しているメソッドが実装されていれば、すぐに動作するはずですが、最適化の余地があれば、この RNG に特化させることもできます。
3. `copy` は擬似乱数生成器（pseudo-RNG）に対して、呼び出された時点から元のものと全く同じ乱数列を生成する独立したコピーを返すべきです。これが実現不可能な場合（例：ハードウェアベースの乱数生成器）、`copy` は実装されてはなりません。

Concerning 1), a `rand` method may happen to work automatically, but it's not officially supported and may break without warnings in a subsequent release.

新しい `rand` メソッドを仮想の `MyRNG` ジェネレーターのために定義し、値の仕様 `s`（例：`s == Int` または `s == 1:10`）を `S==typeof(s)` または `S==Type{s}`（`s` が型の場合）として、前に見たのと同じ2つのメソッドを定義する必要があります。

1. `Sampler(::Type{MyRNG}, ::S, ::Repetition)`は、型`SamplerS`のオブジェクトを返します。
2. `rand(rng::MyRNG, sp::SamplerS)`

`Sampler(rng::AbstractRNG, ::S, ::Repetition)`が`Random`モジュール内ですでに定義されていることがあります。その場合、特定のRNGタイプに対して生成を特化したい場合は、実際にはステップ1)をスキップすることが可能ですが、対応する`SamplerS`タイプは内部の詳細と見なされており、警告なしに変更される可能性があります。

#### Specializing array generation

特定のRNGタイプにおいて、ランダム値の配列を生成する際に、前述のデカップリング技術を単に使用するよりも、特化したメソッドを使用した方が効率的な場合があります。これは、`MersenneTwister`の場合のように、ネイティブにランダム値を配列に書き込むことができる場合です。

`MyRNG`のこの特殊化を実装し、仕様`s`に対して、型`S`の要素を生成するために、次のメソッドを定義できます: `rand!(rng::MyRNG, a::AbstractArray{S}, ::SamplerS)`。ここで、`SamplerS`は`Sampler(MyRNG, s, Val(Inf))`によって返されるサンプラーの型です。`AbstractArray`の代わりに、機能をサブタイプ、例えば`Array{S}`のみに実装することも可能です。`rand`の非破壊的配列メソッドは、内部でこの特殊化を自動的に呼び出します。

```@meta
DocTestSetup = nothing
```

# Reproducibility

与えられたシードで初期化されたRNGパラメータを使用することで、プログラムを複数回実行した際に同じ擬似乱数列を再現することができます。しかし、Juliaのマイナーリリース（例：1.3から1.4）では、特定のシードから生成される擬似乱数の列が*変更される可能性があります*。特に`MersenneTwister`が使用されている場合です。（低レベルの関数[`rand`](@ref)によって生成される列が変更されない場合でも、[`randsubseq`](@ref)のような高レベルの関数の出力はアルゴリズムの更新により変更される可能性があります。）理由：擬似乱数ストリームが決して変更されないことを保証することは、多くのアルゴリズムの改善を禁止します。

ランダムデータの正確な再現性を保証する必要がある場合は、単に*データを保存する*ことをお勧めします（例えば、科学出版物の補足資料として）。 （もちろん、特定のJuliaバージョンやパッケージマニフェストを指定することもできます。特にビット再現性が必要な場合は。）

特定の「ランダム」データに依存するソフトウェアテストは、一般的にデータを保存するか、テストコードに埋め込むか、または [StableRNGs.jl](https://github.com/JuliaRandom/StableRNGs.jl) のようなサードパーティパッケージを使用するべきです。一方で、*ほとんど*のランダムデータに対して合格すべきテスト（例：ランダム行列 `A = randn(n,n)` に対して `A \ (A*x) ≈ x` をテストする）は、固定シードのRNGを使用して、テストを何度も実行しても非常にありえないデータ（例：極端に条件の悪い行列）による失敗が発生しないようにすることができます。

統計的な*分布*からランダムサンプルが抽出される*こと*は、いかなるマイナーなJuliaリリースにおいても同じであることが保証されています。
