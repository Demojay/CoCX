package classes.Scenes.Combat.SpecialsMagic {

import classes.Scenes.Combat.AbstractMagicSpecial;
import classes.Monster;
import classes.PerkLib;
import classes.Scenes.Combat.Combat;
import classes.StatusEffects;
import classes.IMutations.IMutationsLib;
import classes.BodyParts.Tail;
import classes.Scenes.Dungeons.DeepCave.EncapsulationPod;

public class IllusionSkill extends AbstractMagicSpecial {
    public function IllusionSkill() {
        super (
            "Illusion",
            "Warp the reality around your opponent to temporary boost your evasion for 3 rounds and arouse target slightly.",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_BUFF, TAG_MAGICAL, TAG_LUSTDMG],
            PerkLib.EnlightenedKitsune
        )
        lastAttackType = Combat.LAST_ATTACK_LUST;
        baseFatigueCost = 200;
        baseSFCost = 20;
        fatigueType = USEFATG_MAGIC_NOBM;
    }

    override public function get isKnown():Boolean {
        return super.isKnown && player.tailType == Tail.FOX && player.tailCount >= 7 && !player.hasPerk(PerkLib.ElementalBody);
    }

    override public function describeEffectVs(target:Monster):String {
		return "Raises evasion and inflicts ~" + numberFormat(calcLustDamage(target)) + " lust damage";
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

    private function calcLustDamage(monster:Monster):Number {
        var lustDmg:Number = combat.lustDamageCalc();
        if (player.hasPerk(PerkLib.RacialParagon)) lustDmg *= combat.RacialParagonAbilityBoost();
		if (player.hasPerk(PerkLib.EromancyExpert)) lustDmg *= 1.5;
		if (player.hasPerk(PerkLib.NaturalArsenal)) lustDmg *= 1.50;
		if (player.hasPerk(PerkLib.InariBlessedKimono)) lustDmg *= 3;
        if (monster) lustDmg *= monster.lustVuln;
        return lustDmg;
    }

    override public function doEffect(display:Boolean = true):void {
        clearOutput();

        if(monster is EncapsulationPod || monster.inte == 0) {
			if (display) outputText("In the tight confines of this pod, there's no use making such an attack!\n\n");
			return;
		}
        if(monster.hasStatusEffect(StatusEffects.Shell)) {
			if (display) outputText("As soon as your magic touches the multicolored shell around [themonster], it sizzles and fades to nothing.  Whatever that thing is, it completely blocks your magic!\n\n");
			return;
		}

        //Decrease enemy speed and increase their susceptibility to lust attacks if already 110% or more
		if (display) outputText("The world begins to twist and distort around you as reality bends to your will, [themonster]'s mind blanketed in the thick fog of your illusions.");
        var mod:int = 0;
        if (player.hasPerk(PerkLib.TamamoNoMaeCursedKimono)) mod += 1;
		if (player.hasPerk(PerkLib.NaturalInstincts)) mod += 1;

		player.createStatusEffect(StatusEffects.Illusion,3 + mod,0,0,0);

        if (display) {
            if (monster.lustVuln == 0) {
                outputText("  It has no effect!  Your foe clearly does not experience lust in the same way as you.");
            }
            else if (monster.lust < (monster.maxLust() * 0.3)) outputText("[Themonster] squirms as the magic affects [monster him].  ");
            else if (monster.lust >= (monster.maxLust() * 0.3) && monster.lust < (monster.maxLust() * 0.6)) {
                if(monster.plural) outputText("[Themonster] stagger, suddenly weak and having trouble focusing on staying upright.  ");
                else outputText("[Themonster] staggers, suddenly weak and having trouble focusing on staying upright.  ");
            }
            else if (monster.lust >= (monster.maxLust() * 0.6)) {
                outputText("[Themonster]'");
                if(!monster.plural) outputText("s");
                outputText(" eyes glaze over with desire for a moment.  ");
            }
            mosterTeaseText(monster);
        }

        var lustDmg:Number = calcLustDamage(monster);

        monster.teased(lustDmg);
		if (display) outputText("\n\n");
		if (player.hasPerk(PerkLib.EromancyMaster)) combat.teaseXP(1 + combat.bonusExpAfterSuccesfullTease());


    }  
}
}  