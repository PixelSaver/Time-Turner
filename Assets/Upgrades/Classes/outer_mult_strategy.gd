extends BaseUpgradeStrategy
class_name OuterMultStrategy

@export var mult_add : float = 0.2

func apply_upgrade(tt:TimeTurner):
	tt.outer_mults.mult += mult_add
