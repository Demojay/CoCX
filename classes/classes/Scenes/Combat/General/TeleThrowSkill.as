package classes.Scenes.Combat.General {
import classes.PerkLib;
import classes.Monster;
import classes.Scenes.Combat.Combat;
import classes.Scenes.Combat.AbstractGeneral;
import classes.Items.ItemConstants;
import classes.BodyParts.Wings;
import classes.BodyParts.Arms;

public class TeleThrowSkill extends AbstractGeneral {

    public function TeleThrowSkill() {
        super(
            "Telekinesis Throw",
            "Use your powers to throw additional throwing weapons at the enemy",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_DAMAGING, TAG_PHYSICAL],
            PerkLib.Telekinesis
        )
		lastAttackType = Combat.LAST_ATTACK_BOW;
        icon = "A_Ranged";
    }

	override public function describeEffectVs(target:Monster):String {
		return "Deals ~" + numberFormat(calcDamage(target)) + " damage.";
	}

    public function calcDamage(monster:Monster):Number {	
		return 0;
	}

    override public function doEffect(display:Boolean = true):void {
    	var damage:Number = calcDamage(monster);

        if (display) 
            outputText("Weapons begins to float around you as you draw several projectiles from your arsenal using your powers.\n\n");
    
    }
}
}