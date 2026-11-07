[`Face`](@ref)は、テキストを表示するためのグラフィカル属性の集合です。Faceは、ターミナルや、場合によってはその他の場所でのテキストの表示方法を制御します。

ほとんどの場合、[`Face`](@ref)はグローバルなfaces辞書に、*face名*のSymbolとの一意な対応として格納されます。そのため、[`Face`](@ref)オブジェクト自体ではなく、この名前で参照されることがほとんどです。

# Attributes

すべての属性はキーワードコンストラクターで設定でき、デフォルト値は`nothing`です。

  * `height`（`Int`または`Float64`）：高さを指定します。`Int`の場合はデシポイント単位、`Float64`の場合は基本サイズに対する倍率で指定します。
  * `weight`（`Symbol`）：最も薄いものから最も濃いものまで、次のいずれかのSymbolを指定します。`:thin`、`:extralight`、`:light`、`:semilight`、`:normal`、`:medium`、`:semibold`、`:bold`、`:extrabold`、`:black`。ターミナルでは、`:normal`より大きいウェイトはすべて太字で表示されます。また、テキストの明るさを可変にできるターミナルでは、`:normal`より小さいウェイトはすべて薄く表示されます。
  * `slant`（`Symbol`）：次のいずれかのSymbolを指定します。`:italic`、`:oblique`、`:normal`。
  * `foreground`（`SimpleColor`）：テキストの前景色です。
  * `background`（`SimpleColor`）：テキストの背景色です。
  * `underline`（テキストの下線）は、次のいずれかの形式を取ります。

      * `Bool`：テキストに下線を付けるかどうかを指定します。
      * `SimpleColor`：指定した色でテキストに下線を付けます。
      * `Tuple{Nothing, Symbol}`：Symbolで指定したスタイルでテキストに下線を付けます。Symbolには、`:straight`、`:double`、`:curly`、`:dotted`、`:dashed`のいずれかを指定します。
      * `Tuple{SimpleColor, Symbol}`：指定したSimpleColorと、前述のSymbolで指定したスタイルを使ってテキストに下線を付けます。
  * `strikethrough`（`Bool`）：テキストに取り消し線を付けるかどうかを指定します。
  * `inverse`（`Bool`）：前景色と背景色を反転するかどうかを指定します。
  * `inherit`（`Vector{Symbol}`）：継承元となるfaceの名前を指定します。先に指定したfaceが優先されます。すべてのfaceは`:default` faceを継承します。
