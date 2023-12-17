package classes.Scenes.Combat.SpecialsMagic {

import classes.Scenes.Combat.AbstractMagicSpecial;
import classes.StatusEffects;
import classes.Monster;
import classes.Races;
import classes.PerkLib;
import classes.Scenes.Combat.Combat;

public class CursedRiddleSkill extends AbstractMagicSpecial {
    public function CursedRiddleSkill() {
        super (
            "Cursed Riddle",
            "Weave a curse in the form of a magical riddle. If the victims fails to answer it, it will be immediately struck by the curse. Intelligence determines the odds and damage.",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_MAGICAL, TAG_LUSTDMG, TAG_DAMAGING],
            Races.SPHINX
        )
        baseFatigueCost = 50;
        lastAttackType = Combat.LAST_ATTACK_SPELL;
    }

    override public function calcCooldown():int {
        return -1;
    }

    override public function fatigueCost():int {
        return spellCost(50);
    }

    override public function describeEffectVs(target:Monster):String {
		return "Chance to deal  ~" + numberFormat(calcDamage(monster)) + " magical damage, ~" + numberFormat(calcLustDamage(monster)) + "lust damage and to stun";
    }

    public function calcDamage(monster:Monster):Number {
        var damage:Number = ((scalingBonusWisdom() * 0.5) + scalingBonusIntelligence()) * spellMod();
		if (player.headJewelry == headjewelries.SPHINXAS) damage *= 1.5;
        if (player.hasPerk(PerkLib.RacialParagon)) damage *= combat.RacialParagonAbilityBoost();
        if (player.hasPerk(PerkLib.NaturalArsenal)) damage *= 1.50;
        if (player.hasPerk(PerkLib.LionHeart)) damage *= 2;
        return damage;
    }

    public function calcLustDamage(monster:Monster):Number {
        var lustDmg:Number = ((player.inte + (player.wis * 0.50)) / 5 * spellMod() + rand(monster.lib - monster.inte * 2 + monster.cor) / 5);
        if (player.hasPerk(PerkLib.EromancyExpert)) lustDmg *= 1.5;
        if (player.armor == armors.ELFDRES && player.isElf()) lustDmg *= 2;
        if (player.armor == armors.FMDRESS && player.isWoodElf()) lustDmg *= 2;
        if (monster) lustDmg *= monster.lustVuln;
        return lustDmg;
    }

    override public function doEffect(display:Boolean = true):void {
        clearOutput();
        var chosen:String = randomChoice(
		"\"<i>If you speak my name, you destroy me. Who am I?</i>\"\n\n",
		"\"<i>It belongs to me, but both my friends and enemies use it more than me. What is it?</i>\"\n\n",
		"\"<i>What is the part of the bird that is not in the sky, which can swim in the ocean and always stay dry.</i>\"\n\n",
		"\"<i>What comes once in a minute, twice in a moment, but never in a thousand years?</i>\"\n\n",
		"\"<i>The more you take, the more you leave behind. What am I?</i>\"\n\n",
		"\"<i>I reach for the sky, but clutch to the ground; sometimes I leave, but I am always around. What am I?</i>\"\n\n",
		"\"<i>I am a path situated between high natural masses. Remove my first letter & you have a path situated between man-made masses. What am I?</i>\"\n\n",
		"\"<i>I am two-faced but bear only one, I have no legs but travel widely. Men spill much blood over me, kings leave there imprint on me. I have greatest power when given away, yet lust for me keeps me locked away. What am I?</i>\"\n\n",
		"\"<i>I always follow you around, everywhere you go at night. I look very bright to people, but I can make the sun dark. I can be in many different forms and shapes. What am I?</i>\"\n\n",
		"\"<i>I have hundreds of legs but I can only lean. You make me feel dirty so you feel clean. What am I?</i>\"\n\n",
		"\"<i>My tail is long, my coat is brown, I like the country, I like the town. I can live in a house or live in a shed, and I come out to play when you are in bed. What am I?</i>\"\n\n",
		"\"<i>I welcome the day with a show of light, I steathily came here in the night. I bathe the earthy stuff at dawn, But by the noon, alas! I'm gone. What am I?</i>\"\n\n",
		"\"<i>Which creature in the morning goes on four feet, at noon on two, and in the evening upon three?</i>\"\n\n"
		);
		if (display) {
            outputText("You stop fighting for a second and speak aloud a magical riddle.\n\n");
		    outputText(chosen);
		    outputText("Startled by your query, [themonster] gives you a troubled look, everyone knows of the terrifying power of a sphinx riddle used as a curse. You give [themonster] some time crossing your forepaws in anticipation. ");
        }

		//odds of success
		var baseInteReq:Number = 200;
		var chance:Number = Math.max(player.inte/baseInteReq, 0.05) + 25;
		chance = Math.min(chance, 0.80);

		if (Math.random() < chance) {
			if (display) outputText("\n\n[themonster] hazard an answer and your smirk as you respond, \"Sadly incorrect!\" Your curse smites your foe for its mistake, leaving it stunned by pain and pleasure.");
			//damage dealth
			var damage:Number = calcDamage(monster);
			//Determine if critical hit!
			var crit:Boolean = false;
			var critChance:int = 5;
			critChance += combatMagicalCritical();
			if (monster.isImmuneToCrits() && !player.hasPerk(PerkLib.EnableCriticals)) critChance = 0;
			if (rand(100) < critChance) {
				damage *= 1.75;
			}
			damage = Math.round(damage);
			doMagicDamage(damage, true, display);
			if (crit && display) outputText(" <b>*Critical Hit!*</b>");
			//Lust damage dealth
			if (monster.lustVuln > 0) {
				if (display) outputText(" ");
				var lustDmg:Number = calcLustDamage(monster);
				monster.teased(lustDmg, false);
				if (player.hasPerk(PerkLib.EromancyMaster)) combat.teaseXP(1 + combat.bonusExpAfterSuccesfullTease());
			}
			if (!monster.hasPerk(PerkLib.Resolute)) monster.createStatusEffect(StatusEffects.Stunned, 1, 0, 0, 0);
			if (display) outputText("\n\n");
			combat.heroBaneProc(damage);
		}
		else {
			if (display) {
                outputText("\n\nTo your complete frustration, [themonster] answers correctly.");
			    outputText("\n\n");
            }
		}
    }
  
}
}  