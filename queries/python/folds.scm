;Used by nvim-ufo
; Every `[…] @fold` defines what will be folded by default

[
  ; (with_statement)
  ; (try_statement)
  ; (argument_list) ; De facto Funktionsaufrufe, die sich über mehrere Zeilen erstrecken
  (function_definition)
  (import_from_statement)
  (string)
  ; ─── Logging ──────────
  ; log_defaults = {…}
  (assignment
    left: (identifier) @log_defaults (#eq? @log_defaults "log_defaults"))
  ; Alle Logging-Aufrufe, bspw. `logger.info()` oder `logging.info()`
  (call
    function: (attribute
      attribute: (identifier) @log-call)
        (#any-of? @log-call
          "debug"
          "info"
          "warning"
          "error"
          "critical"))
] @fold

; `+`: One or more (like in Regex)
[
  (import_statement)
  (import_from_statement)
]+ @fold
