; extends

(
 (keyed_element
   (literal_element)
   (literal_element) @assignment.inner) @assignment.outer
 . ","? @assignment.outer
)
