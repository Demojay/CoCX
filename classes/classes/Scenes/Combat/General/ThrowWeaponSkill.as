package classes.Scenes.Combat.General {
import classes.PerkLib;
import classes.Monster;
import classes.Scenes.Combat.Combat;
import classes.Scenes.Combat.AbstractGeneral;
import classes.Items.ItemConstants;
import classes.BodyParts.Wings;
import classes.BodyParts.Arms;

public class ThrowWeaponSkill extends AbstractGeneral {

    public function ThrowWeaponSkill() {
        super(
            "Throw Weapon",
            "Attack the oppenent with your ranged weapon",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_DAMAGING, TAG_PHYSICAL],
            null
        )
		lastAttackType = Combat.LAST_ATTACK_BOW;
        icon = "A_Ranged";
    }

    override public function get isKnown():Boolean {
        return player.weaponRangePerk && player.weaponRangePerk != "Tome";
    }

    override public function get buttonName():String {
        var btnName:String = "Throw";

        return btnName;
    }

    override public function get description():String {
        var desc:String = super.description;

        return desc;
    }

    override protected function usabilityCheck():String {
        var uc:String = super.usabilityCheck();
        if (uc) return uc;

        return "";
    }

	override public function describeEffectVs(target:Monster):String {
		return "Deals ~" + numberFormat(calcDamage(target)) + " damage.";
	}

    override public function doEffect(display:Boolean = true):void {
    	var damage:Number = calcDamage(monster);

    }

    public function getNumberOfAttacks():int {
        return 0;
    }

	public function calcDamage(monster:Monster):Number {
		
		return 0;
	}

    
}
}