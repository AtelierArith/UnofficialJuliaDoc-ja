[`Face`](@ref)は、テキストの表示に使うグラフィカル属性の集合です。Faceは、ターミナル上でのテキストの表示方法を制御します。また、ほかの場所での表示にも使われる場合があります。

通常、[`Face`](@ref)はグローバルなfaces辞書に、*face名*を表すSymbolとの一意な対応として格納されます。[`Face`](@ref)オブジェクトそのものではなく、この名前で参照されることがほとんどです。

# Attributes

すべての属性はキーワードコンストラクターで設定でき、デフォルト値は`nothing`です。

  * `height`（`Int`または`Float64`）：高さを指定します。`Int`の場合はデシポイント単位、`Float64`の場合は基準サイズに対する倍率で指定します。
  * `weight`（`Symbol`）：次のSymbolのいずれかを指定します（薄いものから濃いものの順）。`:thin`、`:extralight`、`:light`、`:semilight`、`:normal`、`:medium`、`:semibold`、`:bold`、`:extrabold`、または`:black`。ターミナルでは、`:normal`より大きいウェイトは太字で表示されます。また、テキストの明るさを可変にできるターミナルでは、`:normal`より小さいウェイトは薄く表示されます。
  * `slant`（`Symbol`）：次のSymbolのいずれかを指定します。`:italic`、`:oblique`、または`:normal`。
  * `foreground`（`SimpleColor`）：テキストの前景色です。
  * `background`（`SimpleColor`）：テキストの背景色です。
  * `underline`：テキストの下線です。次の形式を指定できます。

      * `Bool`：テキストに下線を付けるかどうかを指定します。
      * `SimpleColor`：指定した色でテキストに下線を付けます。
      * `Tuple{Nothing, Symbol}`：Symbolで指定したスタイルでテキストに下線を付けます。スタイルには、`:straight`、`:double`、`:curly`、`:dotted`、または`:dashed`を指定します。
      * `Tuple{SimpleColor, Symbol}`：指定したSimpleColorとSymbolのスタイルを使って、テキストに下線を付けます。
  * `strikethrough`（`Bool`）：テキストに取り消し線を付けるかどうかを指定します。
  * `inverse`（`Bool`）：前景色と背景色を反転するかどうかを指定します。
  * `inherit`（`Vector{Symbol}`）：継承元となるface名を指定します。先に指定したfaceが優先されます。すべてのfaceは`:default` faceを継承します。
