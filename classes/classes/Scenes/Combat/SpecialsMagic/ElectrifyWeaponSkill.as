package classes.Scenes.Combat.SpecialsMagic {

import classes.Scenes.Combat.AbstractMagicSpecial;
import classes.Monster;
import classes.Races;
import classes.PerkLib;
import classes.IMutations.IMutationsLib;

public class ElectrifyWeaponSkill extends AbstractMagicSpecial {
    public function ElectrifyWeaponSkill() {
        super (
            "Electrify Weapon",
            "Coat your weapon with a sheet of lusty electricity.",
            TARGET_SELF,
            TIMING_LASTING,
            [TAG_BUFF, TAG_LIGHTNING],
            Races.KIRIN
        )
    }

    override public function get isKnown():Boolean {
        return super.isKnown && player.hasPerk(PerkLib.ElectrifiedDesire) >= 0;
    }

    override public function describeEffectVs(target:Monster):String {
		return "Covers weapon with lightning";
    }

    override public function calcDuration():int {
        var electrifyWeaponDuration:Number = 10;
		if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 1) electrifyWeaponDuration += 1;
		if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 2) electrifyWeaponDuration += 2;
		if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 3) electrifyWeaponDuration += 7;
        return electrifyWeaponDuration;
    }

    override public function doEffect(display:Boolean = true):void {
        clearOutput();
        if (display) outputText("Your lift your weapon toward the sky, drawing bolts of lightning towards it.\n\n");
        setDuration();
    }

    override public function durationEnd(display:Boolean = true):void {
        if (display) outputText("<b>Electrify Weapon effect wore off!</b>\n\n");
    }
}
}  