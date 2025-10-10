extends BaseUpgradeStrategy
class_name CenterMultStrategy

@export var mult_add : float = 0.2

func apply_upgrade(tt:TimeTurner):
	tt.center_mults.mult += mult_add
