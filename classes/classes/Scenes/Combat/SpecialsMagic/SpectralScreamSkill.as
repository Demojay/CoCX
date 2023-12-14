package classes.Scenes.Combat.SpecialsMagic {

import classes.Scenes.Combat.AbstractMagicSpecial;
import classes.StatusEffects;
import classes.Monster;
import classes.Races;
import classes.PerkLib;
import classes.Scenes.Combat.Combat;

public class SpectralScreamSkill extends AbstractMagicSpecial {
    public function SpectralScreamSkill() {
        super (
            "Spectral Scream",
            "Let out a soul-chilling scream to stun your opponent and damage their sanity and soul.",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_MAGICAL, TAG_DAMAGING],
            Races.WENDIGO
        )
		lastAttackType = Combat.LAST_ATTACK_SPELL;
    }

    override public function calcCooldown():int {
		var duration:int = 5;
		if (player.hasPerk(PerkLib.NaturalInstincts)) duration -= 1;
        return duration;
    }

    override public function describeEffectVs(target:Monster):String {
		return "Inflicts  ~" + calcDamage(monster) + " magical damage with the chance to inflict fear";
    }

    public function calcDamage(monster:Monster):Number {
        var damage:Number = scalingBonusIntelligence() * spellMod();
		if (player.hasPerk(PerkLib.RacialParagon)) damage *= combat.RacialParagonAbilityBoost();
		if (player.hasPerk(PerkLib.NaturalArsenal)) damage *= 1.50;
		if (player.hasPerk(PerkLib.LionHeart)) damage *= 2;
        return damage;
    }

    override public function doEffect(display:Boolean = true):void {
        clearOutput();
		if (display) outputText("You let out a soul-chilling scream, freezing your opponent" + 
			(monster.plural ? "s":"") + " in [monster his] tracks from sheer terror. This also seems to have damaged [monster his] sanity. ");
		var damage:Number = calcDamage(monster);
		doMagicDamage(damage, true, display);
		monster.createStatusEffect(StatusEffects.Fear,1+rand(3),0,0,0);
    }
  
}
}  