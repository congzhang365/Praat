form Boundaries in selection on the target tier will be deleted
	comment Would you like to delete on an interval tier?
	boolean interval_tier 0
	real int_tier 
	comment What are the boundaries you would like to delete (including start and end)
	real start_boundary_num 
	real end_boundary_num 
	comment Would you like to delete on a point tier?
	boolean point_tier 0
	real pt_tier 
	real start_point_num 
	real end_point_num
endform

object_name$ = selected$ ("TextGrid")
if interval_tier =1
i = end_boundary_num
repeat
	Remove left boundary: int_tier, i
	i = i - 1
until i = start_boundary_num
endif

if point_tier =1
j = end_point_num
repeat
	Remove point: pt_tier, j
	j = j - 1
until j = start_point_num
endif