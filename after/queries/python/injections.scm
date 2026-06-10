;; extends ; Not necessary because currently this file resided in after/. after/ is meant for extending/appending.
;; `h treesitter-query-modeline`

; Inject `htmldjango` (and by this `javascript` and `css`) into the string highlighting, if a variable name ends on `_HTML`.
((assignment
  left: (identifier) @_name
  right: (string
    (string_content) @injection.content))
  ; #match? compares against a regex pattern
  (#match? @_name "_HTML$")
  ; inject the `htmldjango` sytax highlighting
  (#set! injection.language "htmldjango"))
