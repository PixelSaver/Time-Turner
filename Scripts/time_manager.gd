extends Control
class_name TimeManager
@export var label : RichTextLabel
var current_time : float
var time_turned : float = 0.0
const BIG_BANG_AGE_YEARS : float = 13.8e9
const SECONDS_PER_YEAR : float = 365.25 * 24 * 60 * 60
const BIG_BANG_TIME : float = -BIG_BANG_AGE_YEARS * SECONDS_PER_YEAR
const UNIX_EPOCH_YEAR : int = 1970
const MAX_BC_YEAR : int = 10e4
const YEARS_AGO_THRESHOLD : float = 1e8
func _ready() -> void:
	Global.time_manager = self
func _process(delta: float) -> void:
	current_time = Time.get_unix_time_from_system()
	
	label.text = get_display_time()
## Add an amount to the time turned into the past
func turn_time(amount:float):
	time_turned += amount
## Returns the in-game unix time
func get_simulated_unix() -> float:
	return current_time - time_turned
## Returns the in-game date after time is turned
func get_simulated_datetime() -> Dictionary:
	var simulated_unix = current_time - time_turned
	return Time.get_datetime_dict_from_unix_time(simulated_unix)
	
## Countdown to the end
func distance_to_big_bang() -> float:
	var simulated_unix : float = current_time - time_turned
	var seconds_from_big_bang : float = simulated_unix - BIG_BANG_TIME
	return seconds_from_big_bang / SECONDS_PER_YEAR
func get_display_time() -> String:
	var simulated_unix : float = get_simulated_unix()
	var years_since_big_bang : float = distance_to_big_bang()
	
	if years_since_big_bang <= 0:
		return "Before the Big Bang"
	
	var years_from_epoch : float = simulated_unix / SECONDS_PER_YEAR
	var current_year : int = UNIX_EPOCH_YEAR + int(years_from_epoch)
	
	if current_year > 0:
		var year_start_unix : float = (current_year - UNIX_EPOCH_YEAR) * SECONDS_PER_YEAR
		var seconds_into_year : float = simulated_unix - year_start_unix
		
		if seconds_into_year < 0:
			current_year -= 1
			year_start_unix = (current_year - UNIX_EPOCH_YEAR) * SECONDS_PER_YEAR
			seconds_into_year = simulated_unix - year_start_unix
		
		var total_seconds : int = int(seconds_into_year)
		var days_into_year : int = total_seconds / (24 * 60 * 60)
		var remaining_seconds : int = total_seconds % (24 * 60 * 60)
		
		var hours : int = remaining_seconds / 3600
		remaining_seconds = remaining_seconds % 3600
		var minutes : int = remaining_seconds / 60
		var seconds : int = remaining_seconds % 60
		
		var month : int = (days_into_year / 30) + 1
		var day : int = (days_into_year % 30) + 1
		
		if month > 12:
			month = 12
		if day < 1:
			day = 1
		
		return "%d-%02d-%02d %02d:%02d:%02d AD" % [
			current_year, month, day, hours, minutes, seconds
		]
	
	var bc_year : int = -current_year + 1
	
	if bc_year <= MAX_BC_YEAR:
		var year_start_unix : float = -(bc_year - 1) * SECONDS_PER_YEAR
		var seconds_into_year : float = year_start_unix - simulated_unix
		
		var days_into_year : int = int(seconds_into_year / (24 * 60 * 60))
		var remaining_seconds : float = seconds_into_year - (days_into_year * 24 * 60 * 60)
		
		var hours : int = int(remaining_seconds / 3600)
		remaining_seconds -= hours * 3600
		var minutes : int = int(remaining_seconds / 60)
		var seconds : int = int(remaining_seconds - minutes * 60)
		
		var month : int = int(days_into_year / 30.44) + 1
		var day : int = int(fmod(float(days_into_year), 30.44)) + 1
		
		if month > 12:
			month = 12
		if day > 31:
			day = 31
		
		return "%d-%02d-%02d %02d:%02d:%02d BC" % [
			bc_year, month, day, hours, minutes, seconds
		]
	
	var years_ago : float = BIG_BANG_AGE_YEARS - years_since_big_bang
	
	if years_ago < YEARS_AGO_THRESHOLD:
		var exponent : int = int(floor(log(years_ago) / log(10)))
		var mantissa : float = years_ago / pow(10, exponent)
		return "≈ %.2fe%d years ago" % [mantissa, exponent]
	
	if years_since_big_bang < 1e9:
		return "≈ %.3f million years after Big Bang" % (years_since_big_bang / 1e6)
	else:
		return "≈ %.3f billion years after Big Bang" % (years_since_big_bang / 1e9)
