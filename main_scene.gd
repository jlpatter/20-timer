extends Node2D

const TOTAL_TIME := 1200.0  # 20 minutes
const REST_TIME := 25.0  # 25 seconds

var is_running := false
var is_rest_period := false
var time_remaining := TOTAL_TIME

var grey_stylebox := StyleBoxFlat.new()
var green_stylebox := StyleBoxFlat.new()


func format_time(t: float) -> String:
	var minute := str(int(floor(t / 60.0)))
	var second := str(int(floor(t)) % 60)
	if int(second) < 10:
		second = "0" + second
	
	if minute == "0":
		return second
	return minute + ":" + second


func update_timer(new_time: float) -> void:
	time_remaining = new_time
	$CanvasLayer/TimerLbl.text = format_time(time_remaining)


func set_to_working() -> void:
	update_timer(TOTAL_TIME)
	is_rest_period = false
	$CanvasLayer/BackgroundPanel.add_theme_stylebox_override("panel", grey_stylebox)
	$CanvasLayer/StatusLbl.text = "Working!"


func set_to_resting() -> void:
	update_timer(REST_TIME)
	is_rest_period = true
	$CanvasLayer/BackgroundPanel.add_theme_stylebox_override("panel", green_stylebox)
	$CanvasLayer/StatusLbl.text = "Resting!"


func _ready() -> void:
	grey_stylebox.bg_color = Color.DIM_GRAY
	green_stylebox.bg_color = Color.WEB_GREEN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_running:
		update_timer(time_remaining - delta)
		if time_remaining <= 0.0:
			$AlarmPlayer.play()
			if is_rest_period:
				set_to_working()
			else:
				set_to_resting()


func _on_play_btn_pressed() -> void:
	is_running = not is_running
	if is_running:
		$CanvasLayer/PlayBtn.text = "Pause"
	else:
		$CanvasLayer/PlayBtn.text = "Play"


func _on_stop_btn_pressed() -> void:
	is_running = false
	set_to_working()
