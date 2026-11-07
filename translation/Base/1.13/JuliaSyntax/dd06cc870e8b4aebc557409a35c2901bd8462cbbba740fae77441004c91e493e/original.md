Move `numbytes` from the range at output position `pos+1` to the output position `pos`. If the donor range becomes empty, mark it dead with K"TOMBSTONE" and return `true`, otherwise return `false`.

Hack alert! This is used only for managing the complicated rules related to dedenting triple quoted strings.
