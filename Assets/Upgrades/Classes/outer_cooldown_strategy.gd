extends BaseUpgradeStrategy
class_name OuterCooldownStrategy

@export var mult : float = 0.9

func apply_upgrade(tt:TimeTurner):
	tt.outer_mults.duration *= mult
