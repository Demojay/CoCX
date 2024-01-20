/**
 * Coded by aimozg on 30.05.2017.
 */
package classes.Scenes.Combat {
import classes.GlobalFlags.kFLAGS;
import classes.IMutations.IMutationsLib;
import classes.Items.Weapons.Tidarion;
import classes.Monster;
import classes.PerkLib;
import classes.Races;
import classes.Scenes.API.FnHelpers;
import classes.Scenes.Dungeons.D3.LivingStatue;
import classes.Scenes.NPCs.Jojo;
import classes.Scenes.NPCs.JojoScene;
import classes.StatusEffects;

import coc.view.ButtonData;
import coc.view.ButtonDataList;
import classes.Items.JewelryLib;

public class CombatGeneral extends BaseCombatContent {

	public function CombatGeneral() {
	}

	internal function get weaponRangeAmmo():String {
        var ammoWord:String;
        switch (player.weaponRangeName) {
            case "Lactoblaster":
                ammoWord = "milky streams";
                break;
            case "Touhouna M3":
                ammoWord = "bullets";
                break;
            case "M1 Cerberus":
                ammoWord = "pellets";
                break;
            case "Harkonnen" :
                ammoWord = "shell";
                break;
            case "Harpoon gun" :
                ammoWord = "harpoon";
                break;
            default:
                ammoWord = "bullet";
                break;
        }
        if (player.weaponRangePerk == "Bow") ammoWord = "arrow";
        if (player.weaponRangePerk == "Crossbow") ammoWord = "bolt";
        if (player.weaponRangePerk == "Throwing") ammoWord = "projectile";
        return ammoWord;
    }

    internal function baseRangeAccuracy():Number {
		var baccmod:Number = 128;
		if (player.level > 0) {
			if (player.level > 5) baccmod += 72;
			else baccmod += 12 * player.level;
		}
        if (player.hasPerk(PerkLib.HistoryScout) || player.hasPerk(PerkLib.PastLifeScout)) baccmod += 40;
        baccmod += player.rangedAccuracyStat.value;
        if (player.statusEffectv1(StatusEffects.Kelt) > 0) {
            if (player.statusEffectv1(StatusEffects.Kelt) <= 100) baccmod += player.statusEffectv1(StatusEffects.Kelt);
            else baccmod += 100;
        }
        if (player.statusEffectv1(StatusEffects.Kindra) > 0) {
            if (player.statusEffectv1(StatusEffects.Kindra) <= 150) baccmod += player.statusEffectv1(StatusEffects.Kindra);
            else baccmod += 150;
        }
        if (player.inte > 50 && player.hasPerk(PerkLib.JobHunter)) {
            if (player.inte <= 150) baccmod += (player.inte - 50);
            else baccmod += 100;
        }
        if (player.hasPerk(PerkLib.CarefulButRecklessAimAndShooting)) baccmod += 60;
        if (player.isFlying()) {
            if (player.jewelryName != "Ring of deadeye aim") baccmod -= 100;
            if (player.hasPerk(PerkLib.Aerobatics)) baccmod += 40;
            if (player.hasPerk(PerkLib.AdvancedAerobatics)) baccmod += 100;
        }
		if (player.hasPerk(PerkLib.TrueSeeing)) baccmod += 40;
        if (monster.hasStatusEffect(StatusEffects.EvasiveTeleport) && !player.hasPerk(PerkLib.TrueSeeing)) baccmod -= player.statusEffectv1(StatusEffects.EvasiveTeleport);
        if (player.jewelryName == "Ring of deadeye aim") baccmod += 40;
        if (player.hasMutation(IMutationsLib.HumanEyesIM) && player.racialScore(Races.HUMAN) > 17) {
			baccmod += 10;
			if (player.perkv1(IMutationsLib.HumanEyesIM) >= 3) baccmod += 10;
			if (player.perkv1(IMutationsLib.HumanEyesIM) >= 4) baccmod += 20;
		}
		return baccmod;
	}

    internal function arrowsAccuracyPenalty():Number {
        var accrmodpenalty:Number = 15;
        if (player.hasStatusEffect(StatusEffects.ResonanceVolley)) accrmodpenalty -= 10;
        if (player.perkv1(IMutationsLib.ElvishPeripheralNervSysIM) >= 3) accrmodpenalty -= 5;
		if (player.hasMutation(IMutationsLib.HumanEyesIM) && player.perkv1(IMutationsLib.HumanEyesIM) >= 3 && player.racialScore(Races.HUMAN) > 17) {
			accrmodpenalty -= 5;
			if (player.perkv1(IMutationsLib.HumanEyesIM) >= 4) accrmodpenalty -= 5;
		}
        if (player.weaponRangeName == "Avelynn") accrmodpenalty -= 5;
        if (accrmodpenalty < 0) accrmodpenalty = 0;
        return accrmodpenalty;
    }

    internal function arrowsAccuracy():Number {
        var accmod:Number = 0;
		accmod += baseRangeAccuracy();
		accmod += Math.round((combat.masteryArcheryLevel() - 1) / 2);
        return accmod;
    }
}
}