@tool
extends EditorScript


const FLAG_A: int = (1 << 0)
const FLAG_B: int = (1 << 1)
const FLAG_C: int = (1 << 2)


func _run() -> void:
	var val1 = FLAG_A
	var val2 = FLAG_A | FLAG_B
	var val3 = FLAG_A | FLAG_B | FLAG_C
	
	print(val1, val2, val3)
