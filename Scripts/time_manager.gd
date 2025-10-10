extends Control
class_name TimeManager

@export var label : RichTextLabel
var current_time : float
var time_turned : float = 0.0

const BIG_BANG_AGE_YEARS : float = 13.8e9
const SECONDS_PER_YEAR : float = 365.25 * 24 * 60 * 60
const BIG_BANG_TIME : float = -BIG_BANG_AGE_YEARS * SECONDS_PER_YEAR

func _process(delta: float) -> void:
	current_time = Time.get_unix_time_from_system()
	
	label.text = get_display_time()

## Returns the in-game unix time
func get_simulated_unix() -> float:
	return current_time - time_turned

## Returns the in-game date after time is turned
func get_simulated_datetime() -> Dictionary:
	var simulated_unix = current_time - time_turned
	return Time.get_datetime_dict_from_unix_time(simulated_unix)
	
## Countdown to the end
func distance_to_big_bang() -> float:
	var simulated_unix = current_time - time_turned
	var seconds_from_big_bang = simulated_unix - BIG_BANG_TIME
	return seconds_from_big_bang / SECONDS_PER_YEAR  # in years

func get_display_time() -> String:
	var simulated_unix = get_simulated_unix()
	var years_since_big_bang = distance_to_big_bang()

	# Case 1: Within human time scales (±10⁶ years)
	if abs(years_since_big_bang - BIG_BANG_AGE_YEARS) < 1e6:
		var date = get_simulated_datetime()
		return "%04d-%02d-%02d %02d:%02d:%02d" % [
			date.year, date.month, date.day, date.hour, date.minute, int(date.second)
		]

	# Case 2: Cosmic time scale → use exponential notation
	var delta_years = BIG_BANG_AGE_YEARS - years_since_big_bang
	if delta_years < 0:
		return "In the future (+%.2e years after Big Bang)" % abs(delta_years)
	else:
		return "≈ %.2e years after Big Bang" % (years_since_big_bang)
