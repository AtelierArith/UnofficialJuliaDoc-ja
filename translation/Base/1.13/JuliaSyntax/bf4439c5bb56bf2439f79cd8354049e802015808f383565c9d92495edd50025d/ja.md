トークン種別の文字列表現を返します。種別が K"Identifier" のようなトークンのクラスを表す場合は、`nothing` を返します。

`unique=true` の場合、種別によって対応する入力トークンが一意に定まるときに限り、文字列を返します。それ以外の場合は `nothing` を返します。`unique=false` の場合は、種別の名前を返します。

TODO: `untokenize()` を `Base.string()` に置き換える？
