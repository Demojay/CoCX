package classes.Scenes.Combat.SpecialsMagic {

import classes.Scenes.Combat.AbstractMagicSpecial;
import classes.Monster;
import classes.PerkLib;
import classes.Scenes.Combat.Combat;
import classes.StatusEffects;
import classes.IMutations.IMutationsLib;
import classes.BodyParts.Tail;
import classes.GlobalFlags.kFLAGS;

public class FoxFireSkill extends AbstractMagicSpecial {
    public function FoxFireSkill() {
        super (
            "Fox Fire",
            "Unleash fox flame at your opponent for high damage.",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_FIRE, TAG_MAGICAL, TAG_DAMAGING, TAG_LUSTDMG],
            null
        )
        lastAttackType = Combat.LAST_ATTACK_SPELL;
        baseManaCost = 60;
        baseSFCost = 30;
        manaType = Combat.USEMANA_MAGIC_NOBM;
    }

    override public function get isKnown():Boolean {
        return ((player.tailType == Tail.FOX && player.tailCount >= 2 && player.tailCount < 7) || (player.tailType == Tail.KITSHOO && player.tailCount >= 2)) && !player.hasPerk(PerkLib.ElementalBody);
    }

    override public function describeEffectVs(target:Monster):String {
		return "Inflicts ~" + calcDamage(target, false) + " fire damage and ~" + calcLustDamage(target) + " lust damage";
    }

    override protected function usabilityCheck():String {
        var uc:String = super.usabilityCheck();
        if (uc) return uc;

        if (player.hasStatusEffect(StatusEffects.ThroatPunch) || player.hasStatusEffect(StatusEffects.WebSilence)) {
            return "You cannot focus to use this ability while you're having so much difficult breathing.";
        }

        return "";
    }

    override public function manaCost():Number {
        if (!player.statStore.hasBuff("FoxflamePelt")) {
            return spellCost(baseManaCost * kitsuneskillCost());
        } else {
            return 0;
        }
    }

    override public function sfCost():int {
        if (!player.statStore.hasBuff("FoxflamePelt")) {
            return baseSFCost * soulskillCost() * soulskillcostmulti();
        } else {
            return 0;
        }
    }

    public function calcDamage(monster:Monster, casting:Boolean = false):Number {
        var damage:Number = (scalingBonusWisdom() * 0.5) + (scalingBonusIntelligence() * 0.3);
        damage = calcInfernoMod(damage, casting);
		damage *= 0.25;

        var basicfoxfiredmgmulti:Number = 1;
		basicfoxfiredmgmulti += spellMod() - 1;
		basicfoxfiredmgmulti += soulskillMagicalMod() - 1;
		if (player.shieldName == "spirit focus") basicfoxfiredmgmulti += .2;
		if (player.armorName == "white kimono" || player.armorName == "red kimono" || player.armorName == "blue kimono" || player.armorName == "purple kimono" || player.armorName == "black kimono") basicfoxfiredmgmulti += .2;
		if (player.headjewelryName == "fox hairpin") basicfoxfiredmgmulti += .2;
		if (player.hasPerk(PerkLib.TamamoNoMaeCursedKimono)) basicfoxfiredmgmulti += .5;
		if (player.hasPerk(PerkLib.InariBlessedKimono)) basicfoxfiredmgmulti += 1.5;
		if (player.hasPerk(PerkLib.StarSphereMastery)) basicfoxfiredmgmulti += player.perkv1(PerkLib.StarSphereMastery) * 0.05;
		if (player.hasPerk(PerkLib.NinetailsKitsuneOfBalance)) basicfoxfiredmgmulti += .5;
		//Hosohi No Tama and bonus damage
		if (player.perkv1(IMutationsLib.KitsuneThyroidGlandIM) >= 2) basicfoxfiredmgmulti += 1;
		damage *= basicfoxfiredmgmulti;
		
        //High damage to goes.
		if(monster && monster.short == "goo-girl") damage = Math.round(damage * 1.5);
        damage *= 4;
        if (player.hasPerk(PerkLib.RacialParagon)) damage *= combat.RacialParagonAbilityBoost();
		if (player.hasPerk(PerkLib.NaturalArsenal)) damage *= 1.50;
		if (player.hasPerk(PerkLib.LionHeart)) damage *= 2;
        damage *= combat.fireDamageBoostedByDao();
        return damage;
    }

    public function calcLustDamage(monster:Monster):Number {
        var lustDmg:Number = ((scalingBonusIntelligence(false) / 12 + scalingBonusWisdom(false) / 8) * ((spellMod() + soulskillMagicalMod()) / 2) + rand(monster.lib + monster.cor) / 5);
        if (player.hasPerk(PerkLib.EromancyExpert)) lustDmg *= 1.5;
        if (player.shieldName == "spirit focus") lustDmg *= 1.2;
		if (player.headjewelryName == "fox hairpin") lustDmg *= 1.2;
		if (player.hasPerk(PerkLib.TamamoNoMaeCursedKimono)) lustDmg *= 2.5;
		if (player.hasPerk(PerkLib.InariBlessedKimono)) lustDmg *= 1.5;
		if (player.hasPerk(PerkLib.RacialParagon)) lustDmg *= combat.RacialParagonAbilityBoost();
		if (player.hasPerk(PerkLib.NaturalArsenal)) lustDmg *= 1.50;
		if (player.armor == armors.ELFDRES && player.isElf()) lustDmg *= 2;
		if (player.armor == armors.FMDRESS && player.isWoodElf()) lustDmg *= 2;
        if (monster) lustDmg *= monster.lustVuln;
        return lustDmg;
    }

    override public function doEffect(display:Boolean = true):void {
        clearOutput();

        combat.darkRitualCheckDamage();
		if(monster.hasStatusEffect(StatusEffects.Shell)) {
			if (display) 
                outputText("As soon as your magic touches the multicolored shell around [themonster], it sizzles and fades to nothing.  Whatever that thing is, it completely blocks your magic!\n\n");
			return;
		}
        if (display)
            outputText("Holding out your palm, you conjure fox flame that dances across your fingertips." + 
                "  You launch it at [themonster] with a ferocious throw, and it bursts on impact, showering dazzling sparks everywhere.  ");
        
        var damage:Number = calcDamage(monster, true);
        var lustDmg:Number = calcLustDamage(monster);

        //Determine if critical hit!
		var crit:Boolean = false;
		var critChance:int = 5;
		critChance += combatMagicalCritical();
		if (monster.isImmuneToCrits() && !player.hasPerk(PerkLib.EnableCriticals)) critChance = 0;
		if (rand(100) < critChance) {
			crit = true;
			damage *= 1.75;
		}

        //Using fire attacks on the goo]
        if(monster.short == "goo-girl") {
			if (display)
                outputText("  Your flames lick the girl's body and she opens her mouth in pained protest as you evaporate much of her moisture." + 
                    " When the fire passes, she seems a bit smaller and her slimy [monster color] skin has lost some of its shimmer.  ");
			if(!monster.hasPerk(PerkLib.Acid)) monster.createPerk(PerkLib.Acid,0,0,0,0);
		}
        
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

        monster.teased(lustDmg);
        if (display) outputText(" ");
        doFireDamage(damage, true, display);

        if (display) {
            if (crit) outputText(" <b>*Critical Hit!*</b>");
		    outputText("\n\n");
        }

        flags[kFLAGS.SPELLS_CAST]++;
		if (!player.hasStatusEffect(StatusEffects.CastedSpell)) player.createStatusEffect(StatusEffects.CastedSpell, 0, 0, 0, 0);
		if (player.hasPerk(PerkLib.EromancyMaster)) combat.teaseXP(1 + combat.bonusExpAfterSuccesfullTease());
		spellPerkUnlock();
		combat.heroBaneProc(damage);

    }  
}
}  