extends BaseUpgradeStrategy
class_name InnerCooldownStrategy

@export var mult : float = .9

func apply_upgrade(tt:TimeTurner):
	tt.inner_mults.duration *= mult
