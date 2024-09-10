; extends
(macro_invocation
  (scoped_identifier
     path: (identifier) @_path (#eq? @_path "sqlx")
     name: (identifier) @_name (#eq? @_name "query"))

  (token_tree
    (raw_string_literal) @sql) 
    (#offset! @sql 1 0 0 0))

(macro_invocation
  (scoped_identifier
     path: (identifier) @_path (#eq? @_path "sqlx")
     name: (identifier) @_name (#eq? @_name "query"))

  (token_tree
    (string_literal) @sql) 
    (#offset! @sql 1 0 0 0))
; (
;  ((line_comment) @_comment_start
;    (#eq? @_comment_start "/// ```")) @_start
;
;  (line_comment) @rust
;
;  ((line_comment) @_comment_end
;    (#eq? @_comment_end "/// ```")) @_end
;
;  (#offset! @rust 0 4 0 0)
; )
