extends BaseUpgradeStrategy
class_name InnerMultStrategy

@export var mult : float = 0.2

func apply_upgrade(tt:TimeTurner):
	tt.inner_mults.mult += mult
