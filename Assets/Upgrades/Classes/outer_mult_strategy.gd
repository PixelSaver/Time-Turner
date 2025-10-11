extends BaseUpgradeStrategy
class_name OuterMultStrategy

@export var mult_add : float = 0.1

func apply_upgrade(tt:TimeTurner):
	tt.outer_mults.mult *= (1+mult_add)
