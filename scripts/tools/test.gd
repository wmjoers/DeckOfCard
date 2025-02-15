@tool
extends EditorScript



func _run() -> void:
	var v: Array[int] = [1, 13, 6, 12, 6]
	var t: Array[int] = [9, 10, 3]
		
	print(CardUtils.can_get_any_target(v, t))
		
