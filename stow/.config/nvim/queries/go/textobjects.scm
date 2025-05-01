; extends

(
 (keyed_element
   (literal_element)
   (literal_element) @assignment.inner) @_start
 . ","? @_end
 (#make-range! "assignment.outer" @_start @_end)
)
