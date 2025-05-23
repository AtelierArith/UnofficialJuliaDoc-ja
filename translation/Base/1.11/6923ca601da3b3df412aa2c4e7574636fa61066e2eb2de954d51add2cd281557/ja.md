`AbstractChar`型は、Juliaにおけるすべての文字実装のスーパークラスです。文字はUnicodeコードポイントを表し、[`codepoint`](@ref)関数を介して整数に変換することで、コードポイントの数値を取得したり、同じ整数から構築したりできます。これらの数値は、例えば`<`や`==`で文字を比較する際に使用されます。新しい`T <: AbstractChar`型は、少なくとも`codepoint(::T)`メソッドと`T(::UInt32)`コンストラクタを定義する必要があります。

特定の`AbstractChar`サブタイプは、Unicodeのサブセットのみを表すことができる場合があり、その場合、サポートされていない`UInt32`値からの変換はエラーをスローする可能性があります。逆に、組み込みの[`Char`](@ref)型は、無効なバイトストリームを損失なくエンコードするためにUnicodeの*スーパーセット*を表しており、その場合、非Unicode値を`UInt32`に変換するとエラーがスローされます。[`isvalid`](@ref)関数を使用して、特定の`AbstractChar`型で表現可能なコードポイントを確認できます。

内部的に、`AbstractChar`型はさまざまなエンコーディングを使用する場合があります。`codepoint(char)`を介した変換は、このエンコーディングを明らかにしません。なぜなら、常に文字のUnicode値を返すからです。任意の`c::AbstractChar`の`print(io, c)`は、必要に応じて`Char`に変換することにより、`io`によって決定されるエンコーディング（すべての組み込み`IO`型に対してUTF-8）を生成します。

対照的に、`write(io, c)`は`typeof(c)`に応じたエンコーディングを出力する可能性があり、`read(io, typeof(c))`は`write`と同じエンコーディングを読み取る必要があります。新しい`AbstractChar`型は、独自の`write`および`read`の実装を提供しなければなりません。
