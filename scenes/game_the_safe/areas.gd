extends Node2D


class_name Areas


@onready var add_label: Label = $AddLabel
@onready var sub_label: Label = $SubLabel


var _current_tw: Tween = null


func show_equals() -> void:
	_change_labels("=", "=")


func show_plus_minus() -> void:
	_change_labels("+", "-")


func _change_labels(add: String, sub: String) -> void:
	if add_label.text == add and sub_label.text == sub:
		return
	
	var tw = get_tree().create_tween()
	tw.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	tw.tween_callback(func():
		add_label.text = add
		sub_label.text = sub
	)
	tw.tween_property(self, "modulate", Color.WHITE, 0.2)
	if _current_tw and _current_tw.is_running():
		_current_tw.kill()
	_current_tw = tw
