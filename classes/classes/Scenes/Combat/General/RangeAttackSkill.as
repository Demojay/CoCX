package classes.Scenes.Combat.General {
import classes.PerkLib;
import classes.Monster;
import classes.Scenes.Combat.Combat;
import classes.Scenes.Combat.AbstractGeneral;
import classes.Items.ItemConstants;
import classes.BodyParts.Wings;
import classes.BodyParts.Arms;
import classes.GlobalFlags.kFLAGS;
import classes.StatusEffects;

public class RangeAttackSkill extends AbstractGeneral {
    private var ATTACK_BOW:int = 9;
    private var ATTACK_THROW:int = 9;
    private var ATTACK_GUN:int = 9;

    public function RangeAttackSkill() {
        super(
            "Ranged Attack",
            "Attack the oppenent with your ranged weapon",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_DAMAGING, TAG_PHYSICAL],
            null
        )
		lastAttackType = Combat.LAST_ATTACK_BOW;
        icon = "A_Ranged";
    }

    override public function get buttonName():String {
        var btnName:String = "Throw";

        if (!player.isInGoblinMech() && player.vehicles != vehicles.HB_MECH) { 
            switch (player.weaponRangePerk) {
                case ItemConstants.WT_BOW:                  btnName = "Bow";
                                                            break;
                case ItemConstants.WT_CROSSBOW:             btnName = "Crossbow";
                                                            break;
                case ItemConstants.WT_THROWING:             btnName = "Throw";
                                                            break;
                case ItemConstants.WT_PISTOL:
                case ItemConstants.WT_RIFLE:
                case ItemConstants.WT_2H_FIREARM:
                case ItemConstants.WT_DUAL_FIREARMS:
                case ItemConstants.WT_DUAL_2H_FIREARMS:     btnName = "Shoot";
                                                            break;
            }
        } else if (player.isInGoblinMech() || player.vehicles == vehicles.HB_MECH) {
            btnName = "Shoot";
        }

        return btnName;
    }

    override public function get description():String {
        var desc:String = super.description;

        if (!player.isInGoblinMech() && player.vehicles != vehicles.HB_MECH) { 
            switch (player.weaponRangePerk) {
                case ItemConstants.WT_BOW:                  desc = "Attempt to attack the enemy with your " + player.weaponRangeName + ".  Damage done is determined by your speed and weapon.";
                                                            break;
                case ItemConstants.WT_CROSSBOW:             desc = "Attempt to attack the enemy with your " + player.weaponRangeName + ".  Damage done is determined only by your weapon.";
                                                            break;
                case ItemConstants.WT_THROWING:             desc = "Attempt to throw " + player.weaponRangeName + " at enemy.  Damage done is determined by your strength and weapon.";
                                                            break;
                case ItemConstants.WT_PISTOL:
                case ItemConstants.WT_RIFLE:
                case ItemConstants.WT_2H_FIREARM:
                case ItemConstants.WT_DUAL_FIREARMS:
                case ItemConstants.WT_DUAL_2H_FIREARMS:     desc = "Fire a round at your opponent with your " + player.weaponRangeName + "!  Damage done is determined only by your weapon. <b>AMMO LEFT: "+player.ammo+"</b>";
                                                            break;
            }
        } else if (player.isInGoblinMech()) {
            desc = "Fire a round at your opponent with your " + player.weaponRangeName + "!  Damage done is determined only by your weapon. <b>AMMO LEFT: "+player.ammo+"</b>";
        } else if (player.vehicles == vehicles.HB_MECH) {
            desc = "Attempt to attack the enemy with your mech's inbuilt ranged weapons.  Damage done is determined by your speed and weapon.";
        }


        return desc;
    }

    override protected function usabilityCheck():String {
        var uc:String = super.usabilityCheck();
        if (uc) return uc;

        if (!player.isInGoblinMech() && player.vehicles != vehicles.HB_MECH) {
            if (!player.weaponRangePerk || player.weaponRangePerk == "Tome") {
                return "You cannot use ranged combat without a ranged weapon equipped";
            }   

            if (player.weaponRangePerk == ItemConstants.WT_THROWING && player.ammo <= 0 && player.weaponRange != weaponsrange.SHUNHAR) {
                return "You have used all your throwing weapons in this fight.";
            }

            if (player.isFirearmTypeWeapon() && player.ammo <= 0) {
                return "Your " + player.weaponRangeName + " is out of ammo.  You'll have to reload it before attacking.";
            }

            if (player.isFlying() && (!Wings.Types[player.wings.type].canFly && Arms.Types[player.arms.type].canFly)) {
                return "It would be rather difficult to aim while flapping your arms.";
            }
        } else if (player.isInGoblinMech()) {
            if (!player.isFirearmTypeWeapon()) {
                return "You could use your ranged weapon while piloting a goblin mech if you have firearms.";
            }

            if (!player.isUsingGoblinMechFriendlyFirearms()) {
                return "Your firearms are not compatible with the currently piloted mech.";
            }

            if (!(player.hasKeyItem("Repeater Gun") >= 0 || player.hasKeyItem("Machine Gun MK1") >= 0 || player.hasKeyItem("Machine Gun MK2") >= 0 || player.hasKeyItem("Machine Gun MK3") >= 0)) {
                return "There is no way you could use your ranged weapon while piloting a goblin mech.";
            }
        } else if (player.vehicles == vehicles.HB_MECH) {
            if (!player.isUsingHowlingBansheeMechFriendlyRangeWeapons()) {
                return "Your ranged weapon is not compatible with the currently piloted mech."
            }
        }

        if (monster.hasStatusEffect(StatusEffects.BowDisabled)) {
            return "You can't use your range weapon right now!";
        }

        return "";
    }

	override public function describeEffectVs(target:Monster):String {
		return "Deals ~" + numberFormat(calcDamage(target)) + " damage.";
	}

    override public function doEffect(display:Boolean = true):void {
        var ammoWord:String = combat.weaponRangeAmmo;
        var noOfAttacks:int = getNumberOfAttacks();

        if (monster.hasStatusEffect(StatusEffects.Sandstorm) && rand(10) > 1) {
            if (display) outputText("Your attack" + (noOfAttacks >= 2 ? "s" : "") + " is blown off target by the tornado of sand and wind.  Damn!\n\n");
            return;
        }

        var damageSelection:int = ATTACK_BOW;
        if (player.isThrownTypeWeapon()) damageSelection = ATTACK_THROW;
        else if (player.isFirearmTypeWeapon()) damageSelection = ATTACK_GUN;

    	var damage:Number = calcDamage(monster);

        switch(damageSelection) {
            case ATTACK_THROW:  if (player.hasPerk(PerkLib.Telekinesis)) {
                                    if (display) outputText("Weapons begins to float around you as you draw several projectiles from your arsenal using your powers.\n\n");
                                    telekinesisAttack(display);
                                    if (display) outputText(" Adding to the initial attack, you begin grab additional [weaponrange] before taking aim.\n\n");
                                }
                                break;
            case ATTACK_BOW:    if (display && player.hasStatusEffect(StatusEffects.ResonanceVolley)) {
                                    outputText("Your bow nudges as you ready the next shot, helping you keep your aimed at [monster name].\n\n");
                                }
                                break;
        }
        //TODO: Replace telekinesisAttack with CombatAbility version perform
        //TODO: Add functionality for calculating damage and performing attack round
        
        for(var attackRound:int = 0; attackRound < noOfAttacks; attackRound++)
        {
            var rangeAccPenalty:Number = attackRound;
            var finalRound:Boolean = attackRound == noOfAttacks - 1;
            switch(damageSelection) {
                case ATTACK_GUN:    gunDamageRound(rangeAccPenalty, finalRound, display);
                                    break;
                case ATTACK_THROW:  throwingDamageRound(rangeAccPenalty,finalRound, display);
                                    break;
                case ATTACK_BOW:    
                default:            bowDamageRound(rangeAccPenalty, finalRound, display);
                                    break;
            }            
        }

    }

    public function getNumberOfAttacks():int {
        var maxRangedAttacks:int = player.calculateMultiAttacks(false);
        var attacks:int = 0;
        if (player.vehicles == vehicles.HB_MECH) {
            attacks = 2;
            if (player.hasKeyItem("HB Rapid Reload") >= 0) {
                attacks++;
                if (player.keyItemvX("HB Rapid Reload", 1) == 1) attacks++;
            }
        }
        else if (player.weaponRangePerk == ItemConstants.WT_BOW) {
            attacks = Math.min((flags[kFLAGS.MULTISHOT_STYLE] || 0) + 1, maxRangedAttacks);
			if (player.isWoodElf() && player.hasPerk(PerkLib.ELFTwinShot) && flags[kFLAGS.ELVEN_TWINSHOT_ENABLED]) attacks *= 2;
        }
        else if (player.weaponRangePerk == ItemConstants.WT_CROSSBOW) {
            attacks = Math.min((flags[kFLAGS.MULTISHOT_STYLE] || 0) + 1, maxRangedAttacks);
            if (player.weaponRange == weaponsrange.AVELYNN) attacks *= 3;
        }
        else if (player.weaponRangePerk == ItemConstants.WT_THROWING) {
            attacks = Math.min((flags[kFLAGS.MULTISHOT_STYLE] || 0) + 1, maxRangedAttacks);
        }
        else if (player.isFirearmTypeWeapon()) {
            attacks = Math.min((flags[kFLAGS.MULTISHOT_STYLE] || 0) + 1, maxRangedAttacks);

			if (player.weaponRange == weaponsrange.GOODSAM || player.weaponRange == weaponsrange.BADOMEN) {
				var recoil:Number = 1;
				if (player.str >= 50) recoil += 1;
				if (player.str >= 100) recoil += 1;
				if (player.str >= 200) recoil += 1;
				attacks = recoil;
			}
            else if (player.weaponRange == weaponsrange.TRFATBI || player.weaponRange == weaponsrange.HARPGUN || player.weaponRange == weaponsrange.TOUHOM3 || player.weaponRange == weaponsrange.DERPLAU || player.weaponRange == weaponsrange.DUEL_P_ || player.weaponRange == weaponsrange.FLINTLK) {
				if (flags[kFLAGS.MULTISHOT_STYLE] >= 1 && player.hasPerk(PerkLib.PrimedClipWarp)) {
                    attacks = Math.min(flags[kFLAGS.MULTISHOT_STYLE], 6);
				}
				else if (flags[kFLAGS.MULTISHOT_STYLE] >= 1 && player.hasPerk(PerkLib.TaintedMagazine)) attacks = 2;
				else attacks = 1;
			} else if ((player.weaponRange == weaponsrange.ADBSCAT || player.weaponRange == weaponsrange.ADBSHOT || player.weaponRange == weaponsrange.ALAKABL || player.weaponRange == weaponsrange.DALAKABL || player.weaponRange == weaponsrange.DBDRAGG) && flags[kFLAGS.MULTIPLE_ARROWS_STYLE] > 2) {
				if (flags[kFLAGS.MULTISHOT_STYLE] >= 3 && player.hasPerk(PerkLib.PrimedClipWarp)) {
					attacks = Math.min(flags[kFLAGS.MULTISHOT_STYLE], 6);
				}
				else if (flags[kFLAGS.MULTISHOT_STYLE] >= 3 && player.hasPerk(PerkLib.TaintedMagazine)) {
                    attacks = Math.min(flags[kFLAGS.MULTISHOT_STYLE], 4);
				}
				else attacks = 2;
			} else if ((player.weaponRange == weaponsrange.M1CERBE || player.weaponRange == weaponsrange.TM1CERB || player.weaponRange == weaponsrange.SNIPPLE)) {
                attacks = 1;
            }
            
            if (player.isDualWieldRanged()) attacks *= 2;

            if (attacks >= 2 && player.hasPerk(PerkLib.LockAndLoad)) {
                attacks += Math.floor(attacks / 2);
			}         
        } 

        return attacks;
    }

	public function calcDamage(monster:Monster):Number {
		
		return 0;
	}

    private function bowDamageRound(rangeAccPenalty:Number = 0, finalRound:Boolean = false, display:Boolean = true):void {

    }

    private function throwingDamageRound(rangeAccPenalty:Number = 0, finalRound:Boolean = false, display:Boolean = true):void {

    }

    private function gunDamageRound(rangeAccPenalty:Number = 0, finalRound:Boolean = false, display:Boolean = true):void {

    }
    

    private function telekinesisAttack(display:Boolean = true):void {
    }
}
}