package classes.Scenes.Combat.SpecialsMagic {

import classes.Scenes.Combat.AbstractMagicSpecial;
import classes.StatusEffects;
import classes.Monster;
import classes.Races;
import classes.PerkLib;
import classes.Scenes.Combat.Combat;
import classes.IMutations.IMutationsLib;
import classes.BodyParts.Tail;
import classes.BodyParts.Skin;

public class LustStormSkill extends AbstractMagicSpecial {
    public function LustStormSkill() {
        super (
            "Lust Storm",
            "Supercharge the air with your lusty electricity to unleash a thunderstorm. Can be used once per battle",
            TARGET_ENEMY,
            TIMING_LASTING,
            [TAG_LUSTDMG, TAG_PLASMA, TAG_DAMAGING, TAG_MAGICAL],
            Races.THUNDERBIRD
        )
        lastAttackType = Combat.LAST_ATTACK_SPELL;
        abilityAvailable = FLIGHT_ONLY;
        affectsInvisible = true;
    }

    override public function get isKnown():Boolean {
        return super.isKnown && player.tailType == Tail.THUNDERBIRD && player.hasPerk(PerkLib.ElectrifiedDesire) >= 0;
    }

    override public function calcDuration():int {
        return -1;
    }

    override public function describeEffectVs(target:Monster):String {
		return "Inflicts  ~" + calcDamage(monster, false) + " lightning damage and ~" + calcLustDamage(monster) + " lust damage. Stuns." + 
            " Creates a lingering thunderstorm which deals lightning and lust damage.";
    }

    public function calcDamage(monster:Monster, casting:Boolean = false):Number {
        var damage:Number = scalingBonusIntelligence() * spellModWhite() * 4;
        if (player.hasPerk(PerkLib.ElectrifiedDesire)) damage *= (1 + (player.lust100 * 0.01));
		if (player.hasPerk(PerkLib.RacialParagon)) damage *= combat.RacialParagonAbilityBoost();
		if (player.hasPerk(PerkLib.NaturalArsenal)) damage *= 1.50;
		if (player.hasPerk(PerkLib.LionHeart)) damage *= 2;
        damage *= combat.lightningDamageBoostedByDao();
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
		if (player.hasPerk(PerkLib.NaturalArsenal)) lustDmg *= 1.5;
		
        if (monster) lustDmg *= monster.lustVuln;
        return lustDmg;
    }

    private function calcStormDamage(monster:Monster):Number {
        var stormDamage:Number = scalingBonusIntelligence() * spellModWhite();
        stormDamage = calcVoltageMod(stormDamage, false);
        if (player.hasPerk(PerkLib.ElectrifiedDesire)) stormDamage *= (1 + (player.lust100 * 0.01));
        if (player.hasPerk(PerkLib.RacialParagon)) stormDamage *= combat.RacialParagonAbilityBoost();

        return stormDamage;
    }

    private function calcStormLust(monster:Monster):Number {
        var stormLust:Number = 20 + rand(6);
        stormLust += scalingBonusLibido() * 0.1;
        switch (player.coatType()) {
                case Skin.FUR:
                    stormLust += (1 + player.newGamePlusMod());
                    break;
                case Skin.SCALES:
                    stormLust += (2 * (1 + player.newGamePlusMod()));
                    break;
                case Skin.CHITIN:
                    stormLust += (3 * (1 + player.newGamePlusMod()));
                    break;
                case Skin.BARK:
                    stormLust += (4 * (1 + player.newGamePlusMod()));
                    break;
        }

        stormLust = combat.teases.teaseAuraLustDamageBonus(monster, stormLust);
        if (player.hasPerk(PerkLib.RacialParagon)) stormLust *= combat.RacialParagonAbilityBoost();

        var lustBoostToLustDmg:Number = stormLust * 0.01;
        if (player.lust100 * 0.01 >= 0.9) stormLust += (lustBoostToLustDmg * 140);
        else if (player.lust100 * 0.01 < 0.2) stormLust += (lustBoostToLustDmg * 140);
        else stormLust += (lustBoostToLustDmg * 2 * (20 - (player.lust100 * 0.01)));

        if (monster) stormLust *= monster.lustVuln;
        stormLust /= 2;

        return stormLust;
    }

    override public function advance(display:Boolean):void {
            var stormDamage:Number = calcStormDamage(monster);
            var stormLust:Number = calcStormLust(monster);
            maintainVoltageMod();

            //Determine if critical hit!
            var crit1:Boolean = false;
            var critChance1:int = 5;
            critChance1 += combatMagicalCritical();
            if (monster.isImmuneToCrits() && !player.hasPerk(PerkLib.EnableCriticals)) critChance1 = 0;
            if (rand(100) < critChance1) {
                crit1 = true;
                stormDamage *= 1.75;
            }
            
            dynStats("lus", (Math.round(player.maxLust() * 0.02)), "scale", false);
            
            
            
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
                stormLust *= 1.75;
            }

            
            if (display) outputText("Your opponent is struck by lightning as your lust storm rages on.")
            stormDamage = doLightingDamage(stormDamage, true, true);
            if (crit1 && display) outputText(" <b>*Critical!*</b>");
            monster.teased(stormLust, false);
            if (display) {
                if (crit2) outputText(" <b>Critical!</b>");
                outputText(" as a bolt falls from the sky!\n\n");
            }

            combat.bonusExpAfterSuccesfullTease();
            if (player.hasPerk(PerkLib.EromancyMaster)) combat.teaseXP(1 + combat.bonusExpAfterSuccesfullTease());
            if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 3){
                if (rand(100) < 10) {
                    if (!monster.hasPerk(PerkLib.Resolute)) monster.createStatusEffect(StatusEffects.Stunned,2,0,0,0);
                }
            }
            checkAchievementDamage(stormDamage);
    }

    override public function doEffect(display:Boolean = true):void {
        clearOutput();
        if (display) outputText("You let electricity build up in your body before unleashing it into the ambient sky, the clouds roaring with thunder. Here comes the storm! ");
        var damage:Number = calcDamage(monster);
        var lustDmg:Number = calcLustDamage(monster);

        //Determine if critical hit!
		var crit1:Boolean = false;
		var critChance1:int = 5;
		critChance1 += combatMagicalCritical();
		if (monster.isImmuneToCrits() && !player.hasPerk(PerkLib.EnableCriticals)) critChance1 = 0;
		if (rand(100) < critChance1) {
			crit1 = true;
			damage *= 1.75;
		}

        dynStats("lus", (Math.round(player.maxLust() * 0.02)), "scale", false);

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

        doLightingDamage(damage, true, display);
		if (crit1 && display) outputText(" <b>*Critical!*</b>");
		monster.teased(lustDmg, false);
        if (display) {
            if (crit2) outputText(" <b>Critical!</b>");
            outputText("\n\n");
        }
		combat.teaseXP(1 + combat.bonusExpAfterSuccesfullTease());
		if (player.hasPerk(PerkLib.EromancyMaster)) combat.teaseXP(1 + combat.bonusExpAfterSuccesfullTease());
		if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 3){
			if (rand(100) < 10) {
				if (!monster.hasPerk(PerkLib.Resolute)) monster.createStatusEffect(StatusEffects.Stunned,2,0,0,0);
			}
		}
		checkAchievementDamage(damage);
		combat.heroBaneProc(damage);
    }
  
}
}  