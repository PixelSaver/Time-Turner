extends BaseUpgradeStrategy
class_name CenterMultStrategy

@export var mult_add : float = 0.1

func apply_upgrade(tt:TimeTurner):
	tt.center_mults.mult *= (1+mult_add)
