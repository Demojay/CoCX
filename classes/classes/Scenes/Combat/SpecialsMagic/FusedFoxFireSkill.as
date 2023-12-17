package classes.Scenes.Combat.SpecialsMagic {

import classes.Scenes.Combat.AbstractMagicSpecial;
import classes.Monster;
import classes.PerkLib;
import classes.Scenes.Combat.Combat;
import classes.StatusEffects;
import classes.IMutations.IMutationsLib;
import classes.BodyParts.Tail;
import classes.GlobalFlags.kFLAGS;

public class FusedFoxFireSkill extends AbstractMagicSpecial {
    public function FusedFoxFireSkill() {
        super (
            "Fused Fox Fire",
            "Unleash fused ethereal blue and corrupted purple flame at your opponent for high damage.",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_FIRE, TAG_MAGICAL, TAG_DAMAGING, TAG_LUSTDMG],
            PerkLib.NinetailsKitsuneOfBalance
        )
        lastAttackType = Combat.LAST_ATTACK_SPELL;
        baseManaCost = 200;
        baseSFCost = 100;
        manaType = Combat.USEMANA_MAGIC_NOBM;
    }

    override public function get isKnown():Boolean {
        return super.isKnown && player.tailType == Tail.FOX && player.tailCount >= 7 && !player.hasPerk(PerkLib.ElementalBody);
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
        return spellCost(baseManaCost * kitsuneskillCost());
    }

    override public function sfCost():int {
        return baseSFCost * soulskillCost() * soulskillcostmulti();
    }

    public function calcDamage(monster:Monster, casting:Boolean = false):Number {
        var damage:Number = (scalingBonusWisdom() * 1.5) + scalingBonusIntelligence();
        damage = calcInfernoMod(damage, casting);
		damage *= 0.5;
        if (player.tailType == Tail.FOX && player.tailCount == 9) damage *= 2;

        var fusedfoxfiredmgmulti:Number = 1;
		fusedfoxfiredmgmulti += spellMod() - 1;
		fusedfoxfiredmgmulti += soulskillMagicalMod() - 1;
		if (player.shieldName == "spirit focus") fusedfoxfiredmgmulti += .2;
		if (player.armorName == "white kimono" || player.armorName == "red kimono" || player.armorName == "blue kimono" || player.armorName == "purple kimono" || player.armorName == "black kimono") fusedfoxfiredmgmulti += .2;
		if (player.headjewelryName == "fox hairpin") fusedfoxfiredmgmulti += .2;
		if (player.hasPerk(PerkLib.TamamoNoMaeCursedKimono)) fusedfoxfiredmgmulti += .5;
		if (player.hasPerk(PerkLib.InariBlessedKimono)) fusedfoxfiredmgmulti += 1.5;
		if (player.hasPerk(PerkLib.StarSphereMastery)) fusedfoxfiredmgmulti += player.perkv1(PerkLib.StarSphereMastery) * 0.05;
		if (player.hasPerk(PerkLib.NinetailsKitsuneOfBalance)) fusedfoxfiredmgmulti += .5;
		//Hosohi No Tama and Fusion bonus damage
		if (player.perkv1(IMutationsLib.KitsuneThyroidGlandIM) >= 2 && player.tailType == Tail.FOX && player.tailCount == 9) fusedfoxfiredmgmulti += 1;
		damage *= fusedfoxfiredmgmulti;
        damage*= 2;
		
        //High damage to goes.
		if(monster && monster.short == "goo-girl") damage = Math.round(damage * 1.5);
        damage *= 4;
        if (player.hasPerk(PerkLib.RacialParagon)) damage *= combat.RacialParagonAbilityBoost();
		if (player.hasPerk(PerkLib.NaturalArsenal)) damage *= 1.5;
		if (player.hasPerk(PerkLib.LionHeart)) damage *= 2;
        damage *= combat.fireDamageBoostedByDao();
        return damage;
    }

    public function calcLustDamage(monster:Monster):Number {
        var lustDmg:Number = ((scalingBonusIntelligence(false) / 11 + scalingBonusWisdom(false) / 7) * ((spellMod() + soulskillMagicalMod()) / 2));
        if (monster) lustDmg += rand(monster.lib + monster.cor) / 5;
        if (player.hasPerk(PerkLib.EromancyExpert)) lustDmg *= 1.5;
        if (player.tailType == Tail.FOX && player.tailCount == 9) lustDmg *= 2.8;
		if (player.perkv1(IMutationsLib.KitsuneThyroidGlandIM) >= 2 && player.tailType == Tail.FOX && player.tailCount == 9) lustDmg *= 1.5;
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
            outputText("Holding out your palms, you conjure a ethereal blue flame on one palm, and a corrupted purple flame on the other, dancing across your fingertips." + 
                "  After a well-practised process of fusing both into a giant multi-colored ball of fire, you launch it at [themonster] with a ferocious throw." + 
                " It bursts on impact, showering dazzling azure and lavender sparks everywhere. ");
        
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
                outputText("Your flames lick the girl's body and she opens her mouth in pained protest as you evaporate much of her moisture." + 
                    " When the fire passes, she seems a bit smaller and her slimy [monster color] skin has lost some of its shimmer.  ");
			if(!monster.hasPerk(PerkLib.Acid)) monster.createPerk(PerkLib.Acid,0,0,0,0);
		}
        
        if (display) {
            if (monster.lustVuln == 0) {
                outputText("It has no effect!  Your foe clearly does not experience lust in the same way as you.");
            }
            else if (monster.lust < (monster.maxLust() * 0.3)) outputText("[Themonster] squirms as the magic affects [monster him]. ");
            else if (monster.lust >= (monster.maxLust() * 0.3) && monster.lust < (monster.maxLust() * 0.6)) {
                if(monster.plural) outputText("[Themonster] stagger, suddenly weak and having trouble focusing on staying upright. ");
                else outputText("[Themonster] staggers, suddenly weak and having trouble focusing on staying upright. ");
            }
            else if (monster.lust >= (monster.maxLust() * 0.6)) {
                outputText("[Themonster]'");
                if(!monster.plural) outputText("s");
                outputText(" eyes glaze over with desire for a moment. ");
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