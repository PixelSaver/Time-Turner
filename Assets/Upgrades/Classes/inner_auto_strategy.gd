extends BaseUpgradeStrategy
class_name InnerAutoStrategy

@export var mult : float = 1.

func apply_upgrade(tt:TimeTurner):
	tt.inner_mults.auto += mult
	tt.inner_mults.last_spin = Time.get_unix_time_from_system()
