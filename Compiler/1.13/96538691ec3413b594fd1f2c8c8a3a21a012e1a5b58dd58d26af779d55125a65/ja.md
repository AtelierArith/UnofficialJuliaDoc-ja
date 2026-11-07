Semi NCA アルゴリズムの BB ごとの状態を保持します。元の定式化では、長さ `n` の配列が 3 つあり、`label`、`semi`、`ancestor` がそれに当たります。効率化のため、代わりに array-of-structs 形式で 1 つの配列を使用します。
