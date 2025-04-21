;Used by nvim-ufo
; What will be folded by default
[
  (function_definition)
  (with_statement)
  (try_statement)
  (import_from_statement)
  (argument_list)
  (string)
] @fold

; not sure, what `+` is for
[
  (import_statement)
  (import_from_statement)
]+ @fold
