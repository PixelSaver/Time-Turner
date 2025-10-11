extends BaseUpgradeStrategy
class_name CenterAutoStrategy

@export var mult : float = 1.

func apply_upgrade(tt:TimeTurner):
	tt.center_mults.auto += mult
	tt.center_mults.last_spin = Time.get_unix_time_from_system()
