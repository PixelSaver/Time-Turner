extends BaseUpgradeStrategy
class_name InnerMultStrategy

@export var mult_add : float = 0.1

func apply_upgrade(tt:TimeTurner):
	tt.inner_mults.mult *= (1+mult_add)
