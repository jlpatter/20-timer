extends Node2D

const TOTAL_TIME := 1200.0  # 20 minutes
const REST_TIME := 25.0  # 25 seconds

var is_running := false
var is_rest_period := false
var time_remaining := TOTAL_TIME


func format_time(t: float) -> String:
	var min := str(int(floor(t / 60.0)))
	var sec := str(int(floor(t)) % 60)
	if int(sec) < 10:
		sec = "0" + sec
	
	if min == "0":
		return sec
	return min + ":" + sec


func update_timer(new_time: float) -> void:
	time_remaining = new_time
	$CanvasLayer/TimerLbl.text = format_time(time_remaining)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_running:
		update_timer(time_remaining - delta)
		if time_remaining <= 0.0:
			$AlarmPlayer.play()
			if is_rest_period:
				update_timer(TOTAL_TIME)
				is_rest_period = false
			else:
				update_timer(REST_TIME)
				is_rest_period = true


func _on_play_btn_pressed() -> void:
	is_running = not is_running
	if is_running:
		$CanvasLayer/PlayBtn.text = "Pause"
	else:
		$CanvasLayer/PlayBtn.text = "Play"


func _on_stop_btn_pressed() -> void:
	is_running = false
	update_timer(TOTAL_TIME)
