extends Control

signal start_game

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and $AnyKey.is_visible_in_tree():
			emit_signal("start_game")
			$AnyKey.hide()
			$VBoxContainer.show()
			

func _on_ExitButton_pressed() -> void:
	get_tree().quit()


func _on_Credits_pressed() -> void:
	get_tree().change_scene("res://menu/Credits/Credits.tscn")
