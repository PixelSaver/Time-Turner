extends BaseUpgradeStrategy
class_name InnerUnlockStrategy

@export var mult : float = 0.

func apply_upgrade(tt:TimeTurner):
	tt.inner_mults.unlocked += 1
