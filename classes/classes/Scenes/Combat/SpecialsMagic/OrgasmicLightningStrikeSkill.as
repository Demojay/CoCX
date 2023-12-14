package classes.Scenes.Combat.SpecialsMagic {

import classes.Scenes.Combat.AbstractMagicSpecial;
import classes.StatusEffects;
import classes.Monster;
import classes.Races;
import classes.PerkLib;
import classes.Scenes.Combat.Combat;
import classes.IMutations.IMutationsLib;
import classes.BodyParts.Tail;

public class OrgasmicLightningStrikeSkill extends AbstractMagicSpecial {
    public function OrgasmicLightningStrikeSkill() {
        super (
            "Orgasmic Lightning Strike",
            "Masturbate to unleash a massive discharge.",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_LUSTDMG, TAG_LIGHTNING],
            null
        )
        lastAttackType = Combat.LAST_ATTACK_LUST;
    }

    override public function get isKnown():Boolean {
        return (player.isRaceCached(Races.RAIJU) 
            || (player.isRaceCached(Races.THUNDERBIRD) && player.tailType == Tail.THUNDERBIRD) 
            || player.isRaceCached(Races.KIRIN)) && player.hasPerk(PerkLib.ElectrifiedDesire) >= 0;
    }

    override public function get buttonName():String {
        return "Orgasmic L.S.";
    }

    override public function describeEffectVs(target:Monster):String {
		return "Inflicts  ~" + calcDamage(monster, false) + " lust damage";
    }

    public function calcDamage(monster:Monster, casting:Boolean = false):Number {
        var lustDmgF:Number = combat.teases.teaseBaseLustDamage();
        var lustBoostToLustDmg:Number = 0;
        lustBoostToLustDmg += lustDmgF * 0.01;
        
        if (player.lust100 * 0.01 >= 0.9) {
            lustDmgF += (lustBoostToLustDmg * 140);
        }
        else if (player.lust100 * 0.01 < 0.2) {
            lustDmgF += (lustBoostToLustDmg * 140);
        }
        else {
            lustDmgF += (lustBoostToLustDmg * 2 * (20 - (player.lust100 * 0.01)));
        }

        if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 1) lustDmgF *= 1.1;
        if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 2) lustDmgF *= 1.2;
        if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 3) lustDmgF *= 1.3;
        if (player.hasPerk(PerkLib.RacialParagon)) lustDmgF *= combat.RacialParagonAbilityBoost();
        if (player.hasPerk(PerkLib.NaturalArsenal)) lustDmgF *= 1.5;
        if (monster) lustDmgF *= monster.lustVuln;
        lustDmgF = calcVoltageMod(lustDmgF, casting);

        return lustDmgF;
    }

    override public function doEffect(display:Boolean = true):void {
        clearOutput();
		var temp2:Number;
		if (player.statusEffectv1(StatusEffects.ChanneledAttack) == 2) {
			if (display) outputText("You achieve a thundering orgasm, lightning surging out of your body as you direct it toward [themonster], gleefully zapping [monster him] body with your accumulated lust! Your desire, however, only continues to ramp up.\n\n");
			temp2 = 5 + rand(player.lib / 5 + player.cor / 10);
			dynStats("lus", temp2, "scale", false);

			var lustDmgF:Number = calcDamage(monster, true);

			//Determine if critical tease!
			var crit:Boolean = false;
			var critChance:int = 5;
			if (player.hasPerk(PerkLib.CriticalPerformance)) {
				if (player.lib <= 100) critChance += player.lib / 5;
				if (player.lib > 100) critChance += 20;
			}
			if (monster.isImmuneToCrits() && !player.hasPerk(PerkLib.EnableCriticals)) critChance = 0;
			if (rand(100) < critChance) {
				crit = true;
				lustDmgF *= 1.75;
			}
			
			monster.teased(lustDmgF);
			if (display) {
                if (crit) outputText(" <b>Critical!</b>");
                outputText("\n\n");
            }

			if (player.hasPerk(PerkLib.EromancyMaster)) combat.teaseXP(1 + combat.bonusExpAfterSuccesfullTease());
			if (!monster.hasPerk(PerkLib.Resolute)) monster.createStatusEffect(StatusEffects.Stunned,5,0,0,0);
			player.removeStatusEffect(StatusEffects.ChanneledAttack);
			player.removeStatusEffect(StatusEffects.ChanneledAttackType);
		}
		else if (player.statusEffectv1(StatusEffects.ChanneledAttack) == 1) {
			if (display) outputText("You continue masturbating, lost in the sensation as lightning runs across your form. You are almost there!\n\n");
			temp2 = 5 + rand(player.lib / 5 + player.cor / 10);
			dynStats("lus", temp2, "scale", false);
			player.addStatusValue(StatusEffects.ChanneledAttack, 1, 1);
		}
		else {
			clearOutput();
            if (display) {
                outputText("You begin to fiercely masturbate, ");
                if (player.gender == 2) outputText("fingering your [pussy]");
                if (player.gender == 1) outputText("jerking your [cock]");
                if (player.gender == 3) outputText("jerking your [cock] and fingering your [pussy]");
                outputText(". Static electricity starts to build in your body.\n\n");
            }
			temp2 = 5 + rand(player.lib / 5 + player.cor / 10);
			dynStats("lus", temp2, "scale", false);
			player.createStatusEffect(StatusEffects.ChanneledAttack, 1, 0, 0, 0);
			player.createStatusEffect(StatusEffects.ChanneledAttackType, 3, 0, 0, 0);
		}
    }
  
}
}  