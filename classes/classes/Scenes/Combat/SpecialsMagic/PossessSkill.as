package classes.Scenes.Combat.SpecialsMagic {

import classes.Scenes.Combat.AbstractMagicSpecial;
import classes.Monster;
import classes.Races;
import classes.PerkLib;
import classes.Scenes.Combat.Combat;
import classes.GlobalFlags.kFLAGS;

public class PossessSkill extends AbstractMagicSpecial {
    public function PossessSkill() {
        super (
            "Possess",
            "Attempt to temporarily possess a foe and force them to raise their own lusts.",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_LUSTDMG],
            Races.WENDIGO
        )
        lastAttackType = Combat.LAST_ATTACK_LUST;
    }

    override public function get isKnown():Boolean {
        return (super.isKnown || player.hasPerk(PerkLib.Incorporeality)) && !player.hasPerk(PerkLib.ElementalBody);
    }

    override public function describeEffectVs(target:Monster):String {
		return "Inflicts  ~" + calcLustDamage(target) + " lust damage";
    }

    override public function calcCooldown():int {
        var cooldown:int = 2;
        if (player.hasPerk(PerkLib.NaturalInstincts)) cooldown -= 1;
        return cooldown;
    }

    public function calcLustDamage(monster:Monster):Number {
        var lustDmg:Number = Math.round(player.inte / 5) + rand(player.level) + player.level;
        lustDmg *= Math.round(1 + (0.1 * player.racialScore(Races.POLTERGEIST)));
        if (player.hasPerk(PerkLib.RacialParagon)) lustDmg *= combat.RacialParagonAbilityBoost();
        if (player.hasPerk(PerkLib.NaturalArsenal)) lustDmg *= 1.5;
        if (player.hasPerk(PerkLib.LionHeart)) lustDmg *= 2;
        if (player.hasPerk(PerkLib.EromancyExpert)) lustDmg *= 1.5;
        if (player.armor == armors.ELFDRES && player.isElf()) lustDmg *= 2;
        if (player.armor == armors.FMDRESS && player.isWoodElf()) lustDmg *= 2;
        if (monster) lustDmg *= monster.lustVuln;

        return lustDmg;
    }

    override public function doEffect(display:Boolean = true):void {
        clearOutput();

        var maxIntCapForFail:Number = player.inte;
		var luckyNumber:Number = rand(7);
		if (player.isRaceCached(Races.POLTERGEIST,2)) {
			maxIntCapForFail += Math.round(player.inte * 0.5);
			luckyNumber += 3 + rand(4);
		}
		if (player.isRaceCached(Races.POLTERGEIST,3)) {
			maxIntCapForFail += player.inte;
			luckyNumber += 6 + rand(7);
		}

        if (monster.hasPerk(PerkLib.EnemyGhostType)) {
			outputText("With a smile and a wink, your form becomes completely intangible, and you waste no time in throwing yourself toward the opponent's frame." + 
                "  Sadly, it was doomed to fail, as you bounce right off your foe's ghostly form.");
            return;
        }

        if ((!monster.hasCock() && !monster.hasVagina()) || monster.lustVuln == 0 || monster.inte == 0 || monster.inte > maxIntCapForFail) {
			if (display) {
                outputText("With a smile and a wink, your form becomes completely intangible, and you waste no time in throwing yourself into the opponent's frame.  Unfortunately, it seems ");
                if (monster.inte > maxIntCapForFail) 
                    outputText("they were FAR more mentally prepared than anything you can handle, and you're summarily thrown out of their body before you're even able to have fun with them." + 
                    "  Darn, you muse.\n\n");
                else outputText("they have a body that's incompatible with any kind of possession.\n\n");
            }
            return;
		}

        if (player.inte + luckyNumber - monster.armorMDef < monster.inte) {
            if (display) 
                outputText("With a smile and a wink, your form becomes completely intangible, and you waste no time in throwing yourself into the opponent's frame." + 
                    " Unfortunately, it seems they were more mentally prepared than you hoped, and you're summarily thrown out of their body before you're even able to have fun with them." + 
                    " Darn, you muse. Gotta get smarter.\n\n");
            return;
        }


        var lustDmg:Number = calcLustDamage(monster);
        

        if (player.isRaceCached(Races.POLTERGEIST,3)) {
            lustDmg += Math.round(player.lust * 0.1);
            player.lust -= Math.round(player.lust * 0.1);
        }
        if (player.hasPerk(PerkLib.FueledByDesire) && player.lust100 >= 50 && flags[kFLAGS.COMBAT_TEASE_HEALING] == 0) {
            if (display) outputText("\nYou use your own lust against the enemy, cooling off a bit in the process.");
            player.takeLustDamage(Math.round(-lustDmg)/40, true);
            lustDmg *= 1.2;
        }

        monster.teased(lustDmg);
        if (display) outputText("\n\n");
        if (player.hasPerk(PerkLib.EromancyMaster)) combat.teaseXP(1 + combat.bonusExpAfterSuccesfullTease());

        
    }
  
}
}  