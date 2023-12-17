package classes.Scenes.Combat.SpecialsMagic {

import classes.Scenes.Combat.AbstractMagicSpecial;
import classes.Monster;
import classes.PerkLib;
import classes.Scenes.Combat.Combat;
import classes.StatusEffects;
import classes.IMutations.IMutationsLib;
import classes.BodyParts.Tail;
import classes.Scenes.Dungeons.DeepCave.EncapsulationPod;

public class TerrorSkill extends AbstractMagicSpecial {
    public function TerrorSkill() {
        super (
            "Terror",
            "Instill fear into your opponent with eldritch horrors. The more you cast this in a battle, the less effective it becomes.",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_DEBUFF],
            PerkLib.CorruptedKitsune
        )
        lastAttackType = Combat.LAST_ATTACK_SPELL;
        baseFatigueCost = 200;
        baseSFCost = 20;
        fatigueType = USEFATG_MAGIC_NOBM;
    }

    override public function get isKnown():Boolean {
        return super.isKnown && player.tailType == Tail.FOX && player.tailCount >= 7 && !player.hasPerk(PerkLib.ElementalBody);
    }

    override public function describeEffectVs(target:Monster):String {
		return "Inflicts fear and reduces enemy speed";
    }

    override protected function usabilityCheck():String {
        var uc:String = super.usabilityCheck();
        if (uc) return uc;

        if (player.hasStatusEffect(StatusEffects.ThroatPunch) || player.hasStatusEffect(StatusEffects.WebSilence)) {
            return "You cannot focus to use this ability while you're having so much difficult breathing.";
        }

        return "";
    }

    override public function fatigueCost():int {
        var fatigue:int = baseFatigueCost;
        if ((player.tailCount == 9 && player.tailType == Tail.FOX) || player.perkv1(IMutationsLib.KitsuneParathyroidGlandsIM) >= 1) fatigue /= 2;
        if (player.tailCount == 9 && player.tailType == Tail.FOX && player.perkv1(IMutationsLib.KitsuneParathyroidGlandsIM) >= 1) fatigue /= 2;
        return fatigue * kitsuneskill2Cost();
    }

    override public function sfCost():int {
        return baseSFCost * soulskillCost() * soulskillcostmulti();
    }

    override public function calcCooldown():int {
        var mod:int = 0;
        if (player.hasPerk(PerkLib.TamamoNoMaeCursedKimono)) mod += 1;
		if (player.hasPerk(PerkLib.NaturalInstincts)) mod += 1;
        if ((player.tailCount == 9 && player.tailType == Tail.FOX) || player.perkv1(IMutationsLib.KitsuneParathyroidGlandsIM) >= 1) mod += 2;
        if (player.tailCount == 9 && player.tailType == Tail.FOX && player.perkv1(IMutationsLib.KitsuneParathyroidGlandsIM) >= 1) mod += 2;

        var cooldown:int = 9;
        return cooldown - mod;
    }

    private function calcDebuff(monster:Monster):Number {
        var speedDebuff:Number = 0;
		if (player.perkv1(IMutationsLib.KitsuneParathyroidGlandsIM) >= 3) {
			if (monster.spe >= 71) speedDebuff += 70;
			else speedDebuff += 70 - monster.spe;
		}
		else {
			if (monster.spe >= 21) speedDebuff += 20;
			else speedDebuff += 20 - monster.spe;
		}
		if (player.hasPerk(PerkLib.RacialParagon)) speedDebuff *= combat.RacialParagonAbilityBoost();
		if (player.hasPerk(PerkLib.NaturalArsenal)) speedDebuff *= 1.5;
		if (player.hasPerk(PerkLib.TamamoNoMaeCursedKimono)) speedDebuff *= 2;
        return speedDebuff;
    }

    override public function doEffect(display:Boolean = true):void {
        clearOutput();

        if(monster.hasStatusEffect(StatusEffects.Shell)) {
			if (display) outputText("As soon as your magic touches the multicolored shell around [themonster], it sizzles and fades to nothing.  Whatever that thing is, it completely blocks your magic!\n\n");
			return;
		}
		if(monster is EncapsulationPod || monster.inte == 0) {
			if (display) outputText("You reach for the enemy's mind, but cannot find anything. You frantically search around, but there is no consciousness as you know it in the room.\n\n");
			return;
		}

        //Inflicts fear and reduces enemy SPD.
		if (display) outputText("The world goes dark, an inky shadow blanketing everything in sight as you fill [themonster]'s mind with visions of otherworldly terror that defy description." + 
            " They cower in horror as they succumb to your illusion, believing themselves beset by eldritch horrors beyond their wildest nightmares.\n\n");

        var mod:int = 0;
        if (player.hasPerk(PerkLib.TamamoNoMaeCursedKimono)) mod += 1;
		if (player.hasPerk(PerkLib.NaturalInstincts)) mod += 1;
        var speedDebuff:Number = calcDebuff(monster);

        //monster.speStat.core.value -= speedDebuff;
        monster.buff("Terror").addStats({spe:-speedDebuff}).withText("Terror").combatPermanent();
		monster.createStatusEffect(StatusEffects.Fear, 2 + mod, speedDebuff, 0, 0);

    }  
}
}  