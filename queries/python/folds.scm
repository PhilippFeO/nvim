;Used by nvim-ufo
; Every `[…] @fold` defines what will be folded by default

[
  ; (with_statement)
  ; (try_statement)
  ; (argument_list) ; De facto Funktionsaufrufe, die sich über mehrere Zeilen erstrecken
  (function_definition)
  (import_from_statement)
  (string)
  ; ─── Dataclasses ──────────
  ; Goal: Fold dataclasses but starting at the actual class definition.
  ; TODO(Philipp): Doesn't work. <27-05-2026> 
  ; (decorated_definition
  ;   (decorator
  ;     (identifier) @_decorator
  ;     (#eq? @_decorator "dataclass"))
  ;   (class_definition))
  (decorated_definition
    (decorator
      [
        ; Captures `@dataclass`
        (identifier) @_dec
        ; Captures `@dataclass(…)`
        (call function: (identifier) @_dec)
      ]
      (#eq? @_dec "dataclass"))
        (class_definition))

  ; ─── Logging ──────────
  ; log_defaults = {…}
  (assignment
    left: (identifier) @log_defaults (#eq? @log_defaults "log_defaults"))
  ; logg(er|ing).{debug, info, warning, error, critical}()
  (call
    function: (attribute
      attribute: (identifier) @log-call)
        (#any-of? @log-call
          "debug"
          "info"
          "warning"
          "error"
          "critical"))

  ; parser.add_argument(…)
  (expression_statement
    (call
      function: (attribute
          attribute: (identifier) @fn.add_argument
            (#eq? @fn.add_argument "add_argument")))) 

] @fold

; `+`: One or more (like in Regex)
[
  (import_statement)
  (import_from_statement)
]+ @fold
