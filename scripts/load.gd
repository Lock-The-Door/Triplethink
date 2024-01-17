extends ColorRect

func _ready() -> void:
    var tran = Transitioner.new(true, "home_cutscene")
    tran.transition_time = 3
    add_child(tran)