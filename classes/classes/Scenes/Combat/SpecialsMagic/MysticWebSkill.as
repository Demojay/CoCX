package classes.Scenes.Combat.SpecialsMagic {

import classes.Scenes.Combat.AbstractMagicSpecial;
import classes.Monster;
import classes.PerkLib;
import classes.Scenes.Combat.Combat;
import classes.StatusEffects;
import classes.Scenes.Dungeons.DeepCave.EncapsulationPod;
import classes.BodyParts.LowerBody;
import classes.IMutations.IMutationsLib;
import classes.GlobalFlags.kACHIEVEMENTS;
import classes.GlobalFlags.kFLAGS;

public class MysticWebSkill extends AbstractMagicSpecial {
    public function MysticWebSkill() {
        super (
            "Mystic Web",
            "Spin a thread of animated web using your magic to tie up your victim in place. Also reduce opponent speed after each use.",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_DEBUFF],
            PerkLib.TransformationImmunity2
        )
        lastAttackType = Combat.LAST_ATTACK_SPELL;
        baseManaCost = 50;
    }

    override public function get isKnown():Boolean {
        return  super.isKnown && player.lowerBody == LowerBody.ATLACH_NACHA && !monster.hasStatusEffect(StatusEffects.MysticWeb) && !player.hasPerk(PerkLib.ElementalBody);
    }

    override public function describeEffectVs(target:Monster):String {
		return "Lowers enemy's speed by " + Math.abs(Math.round(calcDebuff(target))) + ". Chance of Stun";
    }

    override protected function usabilityCheck():String {
        var uc:String = super.usabilityCheck();
        if (uc) return uc;

        if (player.tailVenom < 25) {
            return "You do not have enough webbing to shoot right now!";
        }

        if (player.hasStatusEffect(StatusEffects.ThroatPunch) || player.hasStatusEffect(StatusEffects.WebSilence)) {
            return "You cannot focus to use this ability while you're having so much difficult breathing.";
        }

        if (monster && monster is EncapsulationPod) {
            return "You can't web something you're trapped inside of!";
        }

        return "";
    }

    override public function useResources():void {
        super.useResources();
        player.tailVenom -= 25;
		flags[kFLAGS.VENOM_TIMES_USED] += 1;
    }

    override public function manaCost():Number {
        return spellCost(baseManaCost);
    }

    private function calcDebuff(monster:Monster):Number {
        var multiplier:Number = 1;
        if(player.perkv1(IMutationsLib.ArachnidBookLungIM) >= 2) multiplier += 0.5;
        if(player.perkv1(IMutationsLib.ArachnidBookLungIM) >= 3) multiplier += 0.5;
        if(player.hasPerk(PerkLib.RacialParagon)) multiplier += (combat.RacialParagonAbilityBoost() - 1);
        multiplier *= -45;

        return multiplier;
    }

    override public function doEffect(display:Boolean = true):void {
        clearOutput();
        if (display) outputText("You ready your spinner and weave a spell, animating your webbing to immobilise [themonster]. ");

        //WRAP IT UPPP
		if (40 + rand((player.inte + player.lib)/2) > monster.spe) {
			if (display) outputText("A second later [monster he] is firmly tied up by your enchanted thread.");
			monster.createStatusEffect(StatusEffects.MysticWeb, 4 + rand(2),0,0,0);
			
			monster.statStore.addBuffObject({spe:calcDebuff(monster)}, "Web",{text:"Web"});
			if((player.perkv1(IMutationsLib.ArachnidBookLungIM) >= 3 && rand(100) > 50) && !monster.hasPerk(PerkLib.Resolute)) monster.createStatusEffect(StatusEffects.Stunned, 2, 0, 0, 0);
			awardAchievement("How Do I Shot Web?", kACHIEVEMENTS.COMBAT_SHOT_WEB);
		}
		//Failure
		else if (display) { 
            outputText("Your target proves too fast for your technique to catch up.");
		    outputText("\n\n");
        }
    }  
}
}  