package classes.Scenes.Combat.SpecialsMagic {

import classes.Scenes.Combat.AbstractMagicSpecial;
import classes.StatusEffects;
import classes.Monster;
import classes.Races;
import classes.PerkLib;
import classes.Scenes.Combat.Combat;
import classes.IMutations.IMutationsLib;
import classes.lists.Gender;
import classes.BodyParts.Tail;

public class PlasmaBlastSkill extends AbstractMagicSpecial {
    public function PlasmaBlastSkill() {
        super (
            "Plasma Blast",
            "Masturbate to unleash a massive discharge of milk/cum mixed with plasma.",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_LUSTDMG, TAG_PLASMA, TAG_DAMAGING, TAG_MAGICAL],
            null
        )
        lastAttackType = Combat.LAST_ATTACK_SPELL;
    }

    override public function get isKnown():Boolean {
        return ((player.isRaceCached(Races.RAIJU) 
            || (player.isRaceCached(Races.THUNDERBIRD) && player.tailType == Tail.THUNDERBIRD) 
            || player.isRaceCached(Races.KIRIN)) && player.hasPerk(PerkLib.ElectrifiedDesire) >= 0)
            && 
            ((player.hasVagina() && (player.isRaceCached(Races.COW) || player.perkv1(IMutationsLib.LactaBovinaOvariesIM) >= 1 
                || (player.perkv1(IMutationsLib.HumanOvariesIM) >= 3 && player.racialScore(Races.HUMAN) > 17))) 
            || (player.hasCock() && (player.isRaceCached(Races.MINOTAUR) || player.perkv1(IMutationsLib.MinotaurTesticlesIM) >= 1 
                || (player.perkv1(IMutationsLib.HumanTesticlesIM) >= 3 && player.racialScore(Races.HUMAN) > 17)))) ;
    }

    override public function calcCooldown():int {
        var cooldown:int = -1;
        if ((player.perkv1(IMutationsLib.LactaBovinaOvariesIM) >= 3 || player.perkv1(IMutationsLib.MinotaurTesticlesIM) >= 3)) {
            cooldown = 4;
            if (player.hasPerk(PerkLib.NaturalInstincts)) cooldown -= 1;
        }
        return cooldown;
    }

    override public function describeEffectVs(target:Monster):String {
		return "Inflicts  ~" + numberFormat(calcDamage(monster)) + " lightning damage and ~" + numberFormat(calcLustDamage(monster)) + " lust damage. Stuns";
    }

    override protected function usabilityCheck():String {
        var uc:String = super.usabilityCheck();
        if (uc) return uc;

        if (player.gender == Gender.GENDER_NONE) {
            return "You must have some kind of gentials!";
        }

        return "";
    }

    public function calcDamage(monster:Monster):Number {
        var damage:Number = 0;

        switch (player.gender) {
            case Gender.GENDER_MALE:    damage = player.cumQ();
                                        break;
            case Gender.GENDER_FEMALE:  damage = player.lactationQ();
                                        break;
            case Gender.GENDER_HERM:    damage = player.cumQ() + player.lactationQ();
                                        break;
        }

        
        if (player.gender == Gender.GENDER_HERM) {
            damage *= (player.lust100 * 0.02);
            damage *= 1.5;
        } else {
            damage *= (player.lust100 * 0.01);
            damage *= 1.2;
        }
        if (player.hasPerk(PerkLib.RacialParagon)) damage *= combat.RacialParagonAbilityBoost();
		if (player.hasPerk(PerkLib.NaturalArsenal)) damage *= 1.50;
		if (player.hasPerk(PerkLib.LionHeart)) damage *= 2;

        return damage;
    }

    public function calcLustDamage(monster:Monster):Number {
        var lustDmg:Number = combat.teases.teaseBaseLustDamage();

        switch (player.gender) {
            case Gender.GENDER_MALE:    lustDmg += player.cumQ()/100;
                                        lustDmg *= (player.lust100 * 0.01);
                                        break;
            case Gender.GENDER_FEMALE:  lustDmg += player.lactationQ()/100;
                                        lustDmg *= (player.lust100 * 0.01);
                                        break;
            case Gender.GENDER_HERM:    lustDmg += player.lactationQ()/100;
                                        lustDmg += player.cumQ()/100;
                                        lustDmg *= (player.lust100 * 0.01);
                                        break;
        }

        if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 1) lustDmg *= 1.20;
        if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 2) lustDmg *= 1.20;
        if (player.perkv1(IMutationsLib.HeartOfTheStormIM) >= 3) lustDmg *= 1.20;
        if (monster) lustDmg *= monster.lustVuln;
        return lustDmg;
    }

    override public function doEffect(display:Boolean = true):void {
        clearOutput();
        var damage:Number = calcDamage(monster);
        var lustDmg:Number = calcLustDamage(monster);

        if (player.gender == Gender.GENDER_MALE) {
            if (display) {
                if (player.isTaur()) 
                    outputText("You rear up and moan, using your forepaws to jerk and molest your [cock] as you grope your [chest] with your free hands." + 
                    " Finally you scream in thunderous orgasmic bliss as your cock shoots a massive jet of cum mixed with plasma. ");
			    else 
                    outputText("You begin to masturbate fiercely, your [balls] expending with stacked semen as you ready to blow." + 
                    " Your cock shoots a massive jet of cum mixed with plasma, projecting [themonster] away and knocking it prone. ");
            }

        } else if (player.gender == Gender.GENDER_FEMALE) {
            if (display) 
                outputText("You grab both of your udder smirking as you point them toward your somewhat confused target." + 
                " You moan a pleasured Mooooooo as you open the dam, splashing [themonster] with twin jets of milk mixed with plasma so powerful it is blown away, hitting the nearest obstacle. ");

        } else if (player.gender == Gender.GENDER_HERM) {
            if (display) {
                if (player.isTaur()) 
                    outputText("You rear up and moan, using your forepaws to jerk and molest your [cock] as you grope your [chest] with your free hands." + 
                    " Finally you scream in thunderous orgasmic bliss as your cock shoots a massive jet of cum mixed with plasma followed shortly by a twin shot of plasma infused breast milk. ");
			    else 
                    outputText("You moan as you begin to molest your [cock] using your free hand to grope at your [chest]." + 
                    " Finally you scream in a thunderous orgasmic pleasure as your cock shoots a massive jet of cum mixed with plasma followed shortly by a twin shot of plasma infused breast milk. ");
			
            }
        }

        doPlasmaDamage(damage, true, display);

        if (lustDmg > 0) {
            if (display) outputText(" ");
            monster.teased(Math.round(lustDmg));
            combat.teaseXP(1 + combat.bonusExpAfterSuccesfullTease());
        } 
        player.lust += (player.lust100 * 0.1);

        if (!monster.hasPerk(PerkLib.Resolute)) monster.createStatusEffect(StatusEffects.Stunned, 1, 0, 0, 0);
		if (display) outputText("\n\n");
        combat.heroBaneProc(damage);
    }
  
}
}  