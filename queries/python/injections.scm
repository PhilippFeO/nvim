;; extends
; Not necessary because currently this file resided in after/. after/ is meant for extending/appending.
;; `h treesitter-query-modeline`

; There exists also #vim-match? (which doesnt work)

; Inject `htmldjango` (and by this `javascript` and `css`) into the string highlighting, if a variable name ends on `_HTML`.
((assignment
  left: (identifier) @_name
  ; Multiple patterns
  right: [
    (string
      (string_content) @injection.content)
    (parenthesized_expression
      (string
        (string_content) @injection.content))
  ])
  ; #match? compares against a regex pattern
  (#match? @_name "_[hH][tT][mM][lL]$")
  ; inject the `htmldjango` sytax highlighting
  (#set! injection.language "htmldjango"))

((assignment
  left: (identifier) @_name
  right: [
    (string
      (string_content) @injection.content)
    (parenthesized_expression
      (string
        (string_content) @injection.content))
  ])
  ; #match? compares against a regex pattern
  (#match? @_name "_[sS][qQ][lL]$")
  ; inject the `sql` sytax highlighting
  (#set! injection.language "sql"))

((assignment
  left: (identifier) @_name
  right: [
    (string
      (string_content) @injection.content)
    (parenthesized_expression
      (string
        (string_content) @injection.content))
  ])
  ; #match? compares against a regex pattern
  (#match? @_name "_RE$")
  ; inject the `regex` sytax highlighting
  (#set! injection.language "regex"))
