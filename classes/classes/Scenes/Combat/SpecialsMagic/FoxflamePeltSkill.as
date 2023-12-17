package classes.Scenes.Combat.SpecialsMagic {

import classes.Scenes.Combat.AbstractMagicSpecial;
import classes.Monster;
import classes.PerkLib;
import classes.Scenes.Combat.Combat;
import classes.StatusEffects;
import classes.BodyParts.Tail;

public class FoxflamePeltSkill extends AbstractMagicSpecial {
    public function FoxflamePeltSkill() {
        super (
            "Foxflame Pelt",
            "Coat yourself with foxflame pelt. (It would drain soulforce and mana until deactivated).",
            TARGET_SELF,
            TIMING_TOGGLE,
            [TAG_DEBUFF],
            null
        )
        baseSFCost = 50;
        baseManaCost = 100;
        manaType = Combat.USEMANA_MAGIC_NOBM;
    }

    override public function get isKnown():Boolean {
        return player.tailType == Tail.KITSHOO && player.tailCount >= 6 && !player.hasPerk(PerkLib.ElementalBody);
    }

    override public function describeEffectVs(target:Monster):String {
		return "Raises speed by ~" + numberFormat(calcBuff()) + ".";
    }

    override protected function usabilityCheck():String {
        var uc:String = super.usabilityCheck();
        if (uc) return uc;

        if (player.hasStatusEffect(StatusEffects.ThroatPunch) || player.hasStatusEffect(StatusEffects.WebSilence)) {
            return "You cannot focus to use this ability while you're having so much difficult breathing.";
        }

        return "";
    }

    override public function get buttonName():String {
        if (isActive())
            return "Return"
        else
            return _name;
    }

    override public function get description():String {
        if (isActive())
            return "Release foxflames."
        else
            return super.description;
    }

    override public function manaCost():Number {
        return spellCost(baseManaCost * kitsuneskill2Cost())
    }

    override public function sfCost():int {
        return baseSFCost * soulskillCost() * soulskillcostmulti();
    }

    override public function isActive():Boolean {
        return player.statStore.hasBuff("FoxflamePelt");
    }

    public function calcBuff():Number {
		var buff:Number = player.speStat.core.value * 0.1;
        if (player.tailCount >= 7) buff += player.speStat.core.value * 0.1 * (player.tailCount - 6);
        return Math.round(buff);
    }

    override public function doEffect(display:Boolean = true):void {
        clearOutput();
        if (display) outputText("Holding out your palm, you conjure fox flame that dances across your fingertips.  The fire spreads out from all over your arm, covering the rest of your body!\n\n");
        mainView.statsView.showStatUp('spe');
        var oldHPratio:Number = player.hp100/100;
		player.buff("FoxflamePelt").addStats({spe:calcBuff()}).withText("Foxflame Pelt").combatPermanent();
		player.HP = oldHPratio*player.maxHP();

    } 

    override public function toggleOff(display:Boolean = true):void {
        clearOutput();
		if (display) outputText("Gathering you willpower you forcefully extinguish the flames coating your body.");
		player.statStore.removeBuffs("FoxflamePelt");
    }
}
}  