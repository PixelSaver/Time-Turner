extends BaseUpgradeStrategy
class_name CenterCooldownStrategy

@export var mult : float = .9

func apply_upgrade(tt:TimeTurner):
	tt.center_mults.duration *= mult
