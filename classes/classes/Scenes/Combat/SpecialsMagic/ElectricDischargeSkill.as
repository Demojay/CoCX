package classes.Scenes.Combat.SpecialsMagic {

import classes.Scenes.Combat.AbstractMagicSpecial;
import classes.Monster;
import classes.Races;
import classes.PerkLib;
import classes.Scenes.Combat.Combat;
import classes.BodyParts.Wings;
import classes.BodyParts.Antennae;
import classes.BodyParts.Skin;
import classes.StatusEffects;

public class ElectricDischargeSkill extends AbstractMagicSpecial {
    public function ElectricDischargeSkill() {
        super (
            "Electric Discharge",
            "Release a deadly discharge of electricity.",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_DAMAGING, TAG_LIGHTNING, TAG_MAGICAL],
            null
        )
        lastAttackType = Combat.LAST_ATTACK_SPELL;
    }

    override public function get isKnown():Boolean {
        return  player.wings.type == Wings.SEA_DRAGON && 
                player.antennae.type == Antennae.SEA_DRAGON && 
                player.skin.base.pattern == Skin.PATTERN_SEA_DRAGON_UNDERBODY &&
                !player.hasPerk(PerkLib.ElementalBody);
    }

    override public function describeEffectVs(target:Monster):String {
		return "Inflicts  ~" + calcDamage(target, false) + " lightning damage";
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

    override public function doEffect(display:Boolean = true):void {
        clearOutput();
        if (display) outputText("You begin to gather energy within your electrocytes your bodily lights turning bright white as you enter overcharge." + 
            " Suddenly you deliver the amassed current your energy running throught the air like a bright bolt of white death and roaring thunder. ");
        
        if (monster.hasStatusEffect(StatusEffects.DragonWaterBreath)){
			if (display) outputText("Electrified Water is blasted all around your wet target as lightning and fluid turn into a booming explosion the force" + 
                " of wich plaster [monster him] to the ground dazed the violence of the impact! ");
			monster.removeStatusEffect(StatusEffects.DragonWaterBreath);
			if (!monster.hasPerk(PerkLib.Resolute)) monster.createStatusEffect(StatusEffects.Stunned,3,0,0,0);
		}

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
            outputText("\n\n");
        }

        if (player.weapon == weapons.DEMSCYT && player.cor < 90) dynStats("cor", 0.3);
		checkAchievementDamage(damage);
		combat.heroBaneProc(damage);
    }  
}
}  