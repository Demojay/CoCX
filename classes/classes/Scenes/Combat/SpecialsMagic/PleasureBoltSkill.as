package classes.Scenes.Combat.SpecialsMagic {

import classes.Scenes.Combat.AbstractMagicSpecial;
import classes.StatusEffects;
import classes.Monster;
import classes.Races;
import classes.PerkLib;
import classes.Scenes.Combat.Combat;
import classes.IMutations.IMutationsLib;
import classes.BodyParts.Tail;

public class PleasureBoltSkill extends AbstractMagicSpecial {
    public function PleasureBoltSkill() {
        super (
            "Pleasure Bolt",
            "Release a discharge of your lust inducing electricity. It will rise your lust by 2% of max lust after each use.",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_LUSTDMG, TAG_DAMAGING, TAG_MAGICAL, TAG_LIGHTNING],
            null
        )
        lastAttackType = Combat.LAST_ATTACK_SPELL;
    }

    override public function get isKnown():Boolean {
        return (player.isRaceCached(Races.RAIJU) 
            || (player.isRaceCached(Races.THUNDERBIRD) && player.tailType == Tail.THUNDERBIRD) 
            || player.isRaceCached(Races.KIRIN)) && player.hasPerk(PerkLib.ElectrifiedDesire) >= 0;
    }

    override public function describeEffectVs(target:Monster):String {
		return "Inflicts  ~" + calcDamage(monster, false) + " lightning damage and ~" + calcLustDamage(monster) + " lust damage";
    }

    public function calcDamage(monster:Monster, casting:Boolean = false):Number {
        var damage:Number = scalingBonusIntelligence() * spellModWhite() * 4;
        if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 1) damage *= 1.1;
		if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 2) damage *= 1.2;
		if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 3) damage *= 1.3;
        if (player.hasPerk(PerkLib.ElectrifiedDesire)) damage *= (1 + (player.lust100 * 0.01));
		if (player.hasPerk(PerkLib.RacialParagon)) damage *= combat.RacialParagonAbilityBoost();
		if (player.perkv1(IMutationsLib.FloralOvariesIM) >= 1) damage *= 1.25;
		if (player.hasPerk(PerkLib.NaturalArsenal)) damage *= 1.50;
		if (player.hasPerk(PerkLib.LionHeart)) damage *= 2;
		damage = Math.round(damage * combat.lightningDamageBoostedByDao());
        damage = calcVoltageMod(damage, casting);

        return damage;
    }

    public function calcLustDamage(monster:Monster):Number {
        var lustDmg:Number = combat.teases.teaseBaseLustDamage();
        var lustBoostToLustDmg:Number = lustDmg * 0.01;

		if (player.lust100 * 0.01 >= 0.9) lustDmg += (lustBoostToLustDmg * 140);
		else if (player.lust100 * 0.01 < 0.2) lustDmg += (lustBoostToLustDmg * 140);
		else lustDmg += (lustBoostToLustDmg * 2 * (20 - (player.lust100 * 0.01)));

		if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 1) lustDmg *= 1.1;
		if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 2) lustDmg *= 1.2;
		if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 3) lustDmg *= 1.3;
		if (player.hasPerk(PerkLib.RacialParagon)) lustDmg *= combat.RacialParagonAbilityBoost();
		if (player.hasPerk(PerkLib.NaturalArsenal)) lustDmg *= 1.50;
		if (monster) lustDmg *= monster.lustVuln;
        return lustDmg;
    }

    override public function doEffect(display:Boolean = true):void {
        clearOutput();
        if (display) outputText("You gasp in pleasure your body charging up before discharging a bolt of electricity at your foe dealing ");

        var damage:Number = calcDamage(monster, true);

        //Determine if critical hit!
		var crit1:Boolean = false;
		var critChance1:int = 5;
		critChance1 += combatMagicalCritical();
		if (monster.isImmuneToCrits() && !player.hasPerk(PerkLib.EnableCriticals)) critChance1 = 0;
		if (rand(100) < critChance1) {
			crit1 = true;
			damage *= 1.75;
		}

        doLightingDamage(damage, true, display);
        if (display) {
            outputText(" damage. ");
            if (crit1) outputText(" <b>*Critical Hit!*</b>");
        }
        dynStats("lus", (Math.round(player.maxLust() * 0.02)), "scale", false);

        var lustDmg:Number = calcLustDamage(monster);

        //Determine if critical tease!
		var crit2:Boolean = false;
		var critChance2:int = 5;
		if (player.hasPerk(PerkLib.CriticalPerformance)) {
			if (player.lib <= 100) critChance2 += player.lib / 5;
			if (player.lib > 100) critChance2 += 20;
		}
		if (monster.isImmuneToCrits() && !player.hasPerk(PerkLib.EnableCriticals)) critChance2 = 0;
		if (rand(100) < critChance2) {
			crit2 = true;
			lustDmg *= 1.75;
		}

        monster.teased(lustDmg);
        if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 3 && rand(100) < 10 && !monster.hasPerk(PerkLib.Resolute)) monster.createStatusEffect(StatusEffects.Stunned,2,0,0,0);

        if (display) {
            if (crit2) outputText(" <b>Critical!</b>");
            outputText("\n\n");
        }

		combat.teaseXP(1 + combat.bonusExpAfterSuccesfullTease());
		if (player.hasPerk(PerkLib.EromancyMaster)) combat.teaseXP(1 + combat.bonusExpAfterSuccesfullTease());
		if (player.weapon == weapons.DEMSCYT && player.cor < 90) dynStats("cor", 0.3);
		checkAchievementDamage(damage);
		combat.heroBaneProc(damage);
    }
  
}
}  