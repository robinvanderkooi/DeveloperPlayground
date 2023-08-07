extends Node

static func Vector2ArrayToHull(point_array) -> Array:
	var new_point_array = Array()
	
	var point_minX = point_array[0]
	var point_maxX = point_array[0]
	
	#Get the first 2 points
	for point in point_array:
		if point.x < point_minX.x:
			point_minX = point
		if point.x > point_maxX.x:
			point_maxX = point
			
	for point in point_array:
		if point_minX != point and point_maxX != point:
			new_point_array.append(point)
	
	var resulting_array:Array = Array()
	resulting_array.append_array( Vector2ArrayToHull_side(point_minX, point_maxX, new_point_array) )
	resulting_array.append_array( Vector2ArrayToHull_side(point_maxX, point_minX, new_point_array) )
	return resulting_array
	

static func Vector2ArrayToHull_side(point_left:Vector2, point_right:Vector2, point_array:Array) -> Array:
	if point_array.size() == 0:
		return [point_left]
	
	var new_point_array = Array()
	
	# Calculate vector from `a` to `b`.
	var dvec = (point_right - point_left).normalized()
	# Rotate 90 degrees.
	var N = Vector2(dvec.y, -dvec.x)
	#Distance to origin. 
	#A line through the origin and a line through the 2 points will always be the same distance apart.
	var D = N.dot(point_left)
	
	var farthest_point:Vector2
	var farthest_distance:float = 0
	for n in range(0, point_array.size()):
		var newDistance = N.dot(point_array[n]) - D
		if newDistance > farthest_distance:
			farthest_distance = newDistance
			farthest_point = point_array[n]
		if newDistance > 0.01:
			new_point_array.append(point_array[n])
	
	#return if no results. There is only one side.
	if new_point_array.size() == 0:
		return [point_left]
	
	#return the appended version of 2 calls
	var resulting_array:Array = Array()
	resulting_array.append_array( Vector2ArrayToHull_side(point_left, farthest_point, new_point_array) )
	resulting_array.append_array( Vector2ArrayToHull_side(farthest_point, point_right, new_point_array) )
	return resulting_array
	
	
	
#static func DistanceToLine(line_A:float, line_B:float, line_C:float, point_x:float, point_y:float) -> float:
##	d = |Ax1 + By1 + C|]/ √(A2 + B2)
#	var top_stuff = abs(line_A * point_x + line_B * point_y + line_C)
#	var bottom_stuff = sqrt(line_A * line_A + line_B * line_B)
#
#	var distance = top_stuff / bottom_stuff
#	return distance

