; extends

(
 (keyed_element
   (literal_element)
   (literal_element) @value.inner) @_start
 . ","? @_end
 (#make-range! "value.outer" @_start @_end)
)

right: (expression_list) @value.inner @value.outer
