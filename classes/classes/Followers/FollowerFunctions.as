package classes.Followers {

import classes.Scenes.Combat.BaseCombatContent;
import classes.PerkLib;
import classes.Monster;
import classes.StatusEffects;
import classes.IMutations.IMutationsLib;
import classes.EngineCore;
import classes.StatusEffectClass;
import classes.Scenes.Places.TelAdre.UmasShop;
import classes.GlobalFlags.kFLAGS;

public class FollowerFunctions extends BaseCombatContent{

    public function FollowerFunctions() {}

    public function increasedEfficiencyOfAttacks():Number {
        var IEoA:Number = 0;
        if (player.hasPerk(PerkLib.Motivation)) {
            IEoA += 0.5;
        }
        if (player.hasPerk(PerkLib.MotivationEx)) {
            if (player.level >= 6) IEoA += 0.5;
            if (player.level >= 27) IEoA += 0.5;
            if (player.level >= 54) IEoA += 0.5;
            if (player.level >= 102) IEoA += 0.5;
        }
        if (player.hasPerk(PerkLib.MotivationSu)) IEoA *= 1.5;
        IEoA += 1;
        //ITEMS EFFEC TS? MISC ACC / RINGS / NECK / HEAD ACC, WEAPON?
        return IEoA;
    }

    public function taticianBonus(damage:Number):Number {
        if (player.hasPerk(PerkLib.HistoryTactician) || player.hasPerk(PerkLib.PastLifeTactician)) damage *= combat.historyTacticianBonus();
        return damage;
    }

    public function scalingWeapon(weaponAtk:Number, dmg:Number = -1):Number {
        if (dmg == -1)
            dmg = weaponAtk;

        if (weaponAtk < 51) dmg *= (1 + (weaponAtk * 0.03));
        else if (weaponAtk >= 51 && weaponAtk < 101) dmg *= (2.5 + ((weaponAtk - 50) * 0.025));
        else if (weaponAtk >= 101 && weaponAtk < 151) dmg *= (3.75 + ((weaponAtk - 100) * 0.02));
        else if (weaponAtk >= 151 && weaponAtk < 201) dmg *= (4.75 + ((weaponAtk - 150) * 0.015));
        else dmg *= (5.5 + ((weaponAtk - 200) * 0.01));

        return dmg;
    }

    public function doDamageFollower(follower:Follower, damage:Number, apply:Boolean = true, display:Boolean = false, ignoreDR:Boolean = false):Number {
        damage *= combat.doDamageReduction();
		if (!ignoreDR) damage *= (monster.damagePercent() / 100);
		if (damage < 1) damage = 1;
		if (monster.damageReductionBasedOnDifficulty() > 1) damage *= (1 / monster.damageReductionBasedOnDifficulty());
        if (monster.hasStatusEffect(StatusEffects.TranscendentSoulField)) damage *= (1 / monster.statusEffectv1(StatusEffects.TranscendentSoulField));
        if (monster.hasStatusEffect(StatusEffects.ATranscendentSoulField)) damage *= (1 / monster.statusEffectv1(StatusEffects.ATranscendentSoulField));
        if (monster.hasStatusEffect(StatusEffects.NecroticRot)) damage *= (1 + (0.25 * monster.statusEffectv1(StatusEffects.NecroticRot)));
        if (follower.hasStatusEffect(StatusEffects.Minimise)) damage *= 0.01;
        if (follower.hasPerk(PerkLib.Sadist)) {
            damage *= 1.2;
            if (follower.armorName == "Scandalous Succubus Clothing") {
                damage *= 1.2;
            }
        }
        if (monster.hasStatusEffect(StatusEffects.BerzerkingSiegweird)) damage *= 1.2;
        if (follower.hasPerk(PerkLib.Anger) && (follower.hasStatusEffect(StatusEffects.Berzerking) || follower.hasStatusEffect(StatusEffects.Lustzerking))) {
            var bonusDamageFromMissingHP:Number = 1;
            if (follower.hp100 < 100) {
                if (follower.hp100 < 1) bonusDamageFromMissingHP += 0.99;
                else bonusDamageFromMissingHP += (1 - (follower.hp100 * 0.01));
            }
            damage *= bonusDamageFromMissingHP;
        }
        if (monster.hasStatusEffect(StatusEffects.IceArmor)) damage *= 0.1;
        if (monster.hasStatusEffect(StatusEffects.DefendMonsterVer)) damage *= (1 - monster.statusEffectv2(StatusEffects.DefendMonsterVer));
        if (monster.hasStatusEffect(StatusEffects.Provoke)) damage *= monster.statusEffectv2(StatusEffects.Provoke);
		if (follower.hasPerk(PerkLib.KnowledgeIsPower)) {
			if (follower.perkv1(IMutationsLib.RatatoskrSmartsIM) >= 3) damage *= (1 + (Math.round(camp.codex.checkUnlocked() / 100) * 3));
			else damage *= (1 + Math.round(camp.codex.checkUnlocked() / 100));
		}
		damage *= follower.eyesOfTheHunterDamageBonus();
		if (monster.hasPerk(PerkLib.EnemyGhostType)) damage = 0;
        if (monster.HP - damage <= monster.minHP()) {
            doNext(endHpVictory);
        }
        // Uma's Massage Bonuses
        var sac:StatusEffectClass = follower.statusEffectByType(StatusEffects.UmasMassage);
        if (sac) {
            if (sac.value1 == UmasShop.MASSAGE_POWER) {
                damage *= sac.value2;
            }
        }
        damage = Math.round(damage);
        if (damage < 0) damage = 1;
        if (apply) {
            damage = monster.doDamageBefore(damage);
            if(damage<=0){
                return 0;
            }
            monster.HP -= damage;
			var WrathGains:Number = 0;
            var BonusWrathMult:Number = 1;
            if (monster.hasPerk(PerkLib.BerserkerArmor)) BonusWrathMult = 1.20;
            if (monster.hasPerk(PerkLib.FuelForTheFire)) WrathGains += Math.round((damage / 5)*BonusWrathMult);
            else WrathGains += Math.round((damage / 10) * BonusWrathMult);
			monster.wrath += WrathGains;
            if (monster.wrath > monster.maxOverWrath()) monster.wrath = monster.maxOverWrath();
        }
        if (display) combat.CommasForDigits(damage);
        //Interrupt gigaflare if necessary.
        if (monster.hasStatusEffect(StatusEffects.Gigafire)) monster.addStatusValue(StatusEffects.Gigafire, 1, damage);
        //Keep shit in bounds.
        if (monster.HP < monster.minHP()) monster.HP = monster.minHP();
        return damage;
    }

}
}