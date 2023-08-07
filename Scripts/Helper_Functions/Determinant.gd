extends Node

static func Determinant2x2(v) -> float:
	#Matrix it accross the top, then down
#	var a = v[0].x
#	var b = v[0].y
#	var c = v[1].x
#	var d = v[1].y
#	return (a * d) - (b * c)
	return (v[0].x * v[1].y) - (v[0].y * v[1].x)

static func Determinant3x3(v) -> float:
	var t1 = v[0].x * Determinant2x2([Vector2(v[1].y,v[1].z),Vector2(v[2].y,v[2].z)])
	var t2 = v[0].y * Determinant2x2([Vector2(v[1].z,v[1].x),Vector2(v[2].z,v[2].x)])
	var t3 = v[0].z * Determinant2x2([Vector2(v[1].x,v[1].y),Vector2(v[2].x,v[2].y)])
	return t1 + t2 + t3

static func Is_D_In_CircleABC(a:Vector2,b:Vector2,c:Vector2,d:Vector2) -> bool:
	var tl = a.x - d.x
	var tm = a.y - d.y
	var tr = pow(tl,2) + pow(tm,2)
	var ml = b.x - d.x
	var mm = b.y - d.y
	var mr = pow(ml,2) + pow(mm,2)
	var bl = c.x - d.x
	var bm = c.y - d.y
	var br = pow(bl,2) + pow(bm,2)
	var row1 = Vector3(tl,tm,tr)
	var row2 = Vector3(ml,mm,mr)
	var row3 = Vector3(bl,bm,br)
	var det = Determinant3x3([row1,row2,row3])
	return det > 0

