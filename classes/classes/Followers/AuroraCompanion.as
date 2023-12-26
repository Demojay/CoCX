package classes.Followers {

import classes.internals.SaveableState;
import classes.Saves;
import classes.IMutations.IMutationsLib;
import classes.PerkLib;
import classes.AssClass;
import classes.StatusEffects;
import classes.VaginaClass;
import classes.Appearance;
import classes.BodyParts.Hips;
import classes.BodyParts.Butt;
import classes.StatusEffectType;
import classes.Monster;
import classes.CoC;

public class AuroraCompanion extends Follower implements SaveableState{

    public function AuroraCompanion() { 
        Saves.registerSaveableState(this);
        levelCap = 13;
        timerStatusEffect = StatusEffects.CampSparingNpcsTimers4;
        timerStatusPosition = 2;
    }

    public function resetState():void {
    	followerLevel = 1;
        defeats = 0;
    }

    public function saveToObject():Object {
    	return {
            "followerLevel": followerLevel,
            "defeats": defeats
        };
    }

    public function loadFromObject(o:Object, ignoreErrors:Boolean):void{
    	if(o) {
            followerLevel = o.followerLevel;
            defeats = o.defeats;
        } else  {
            resetState();
        }

        setUp();
    }

    public function stateObjectName():String
    {
    	return "AuroraCompanion";
    }

    private function setUp():void {
        this.a = "";
        this.short = "Aurora";
        this.imageName = "aurora";
        this.long = "Before you stands Aurora at 9 feet tall, she has an overall thicker body than most golems. Right above where her cleavage begins, is a black tattoo with the letter A above 3 lines, forming the Roman numeral 3. Her skin is a light turquoise with blue markings all over and a white belly. Two huge bat wings come from her back, and she has a long tail ending in blue fur. Around her neck is a mane of light blue fur. Two huge bat ears swivel around from the top of her head, detecting all noises in the area.";
        this.plural = false;
        this.createVagina(false, VaginaClass.WETNESS_SLAVERING, VaginaClass.LOOSENESS_NORMAL);
        this.createStatusEffect(StatusEffects.BonusVCapacity, 30, 0, 0, 0);
        createBreastRow(Appearance.breastCupInverse("HHH"));
        this.ass.analLooseness = AssClass.LOOSENESS_NORMAL;
        this.ass.analWetness = AssClass.WETNESS_NORMAL;
        this.tallness = 108;//9 feet
        this.hips.type = Hips.RATING_CURVY + 4;
        this.butt.type = Butt.RATING_EXPANSIVE + 1;
        this.bodyColor = "turquoise";
        this.hairColor = "navy blue";
        this.hairLength = 20;
        this.weaponName = "claws";
        this.weaponVerb = "claw-slash";
        this.armorName = "stone skin";
        this.gems = 0;
        this.drop = NO_DROP;
        
        setInitialPerks();
        setStats();
        setPerks();
        checkMonster();
        prepareForCombat();
    }

    override public function setInitialPerks():void {
        this.createPerk(PerkLib.EnemyConstructType, 0, 0, 0, 0);
        this.createPerk(PerkLib.Sentience, 0, 0, 0, 0);
        this.createPerk(PerkLib.JobSoulCultivator, 0, 0, 0, 0);
        this.createPerk(PerkLib.FleshBodyApprenticeStage, 0, 0, 0, 0);
        this.createPerk(PerkLib.UnlockArdor, 0, 0, 0, 0);
        this.createPerk(PerkLib.JobBeastWarrior, 0, 0, 0, 0);
    }

    override public function setStats():void {
        if (followerLevel == 1) {
				initStrTouSpeInte(10, 300, 30, 80);
				initWisLibSensCor(80, 20, 10, 50);
				this.weaponAttack = 5;
				this.armorDef = 105;
				this.armorMDef = 105;
				this.bonusHP = 100;
				this.bonusLust = 31;
				this.level = 1;
			}
			if (followerLevel == 2) {
				initStrTouSpeInte(50, 300, 80, 85);
				initWisLibSensCor(85, 30, 15, 50);
				this.weaponAttack = 9;
				this.armorDef = 105;
				this.armorMDef = 105;
				this.bonusHP = 700;
				this.bonusLust = 52;
				this.level = 7;
			}
			if (followerLevel == 3) {
				initStrTouSpeInte(90, 320, 130, 90);
				initWisLibSensCor(90, 40, 20, 50);
				this.weaponAttack = 15;
				this.armorDef = 112;
				this.armorMDef = 112;
				this.bonusHP = 1300;
				this.bonusLust = 73;
				this.level = 13;
			}
			if (followerLevel == 4) {
				initStrTouSpeInte(130, 320, 180, 95);
				initWisLibSensCor(95, 50, 25, 50);
				this.weaponAttack = 23;
				this.armorDef = 112;
				this.armorMDef = 112;
				this.bonusHP = 1900;
				this.bonusLust = 94;
				this.level = 19;
			}
			if (followerLevel == 5) {
				initStrTouSpeInte(170, 340, 230, 100);
				initWisLibSensCor(100, 60, 30, 50);
				this.weaponAttack = 33;
				this.armorDef = 119;
				this.armorMDef = 119;
				this.bonusHP = 2500;
				this.bonusLust = 115;
				this.level = 25;
			}
			if (followerLevel == 6) {
				initStrTouSpeInte(210, 340, 280, 105);
				initWisLibSensCor(105, 70, 35, 50);
				this.weaponAttack = 45;
				this.armorDef = 119;
				this.armorMDef = 119;
				this.bonusHP = 3100;
				this.bonusLust = 136;
				this.level = 31;
			}
			if (followerLevel == 7) {
				initStrTouSpeInte(250, 360, 330, 110);
				initWisLibSensCor(110, 80, 40, 50);
				this.weaponAttack = 59;
				this.armorDef = 126;
				this.armorMDef = 126;
				this.bonusHP = 3700;
				this.bonusLust = 157;
				this.level = 37;
			}
			if (followerLevel == 8) {
				initStrTouSpeInte(290, 360, 380, 115);
				initWisLibSensCor(115, 90, 45, 50);
				this.weaponAttack = 75;
				this.armorDef = 126;
				this.armorMDef = 126;
				this.bonusHP = 4300;
				this.bonusLust = 178;
				this.level = 43;
			}
			if (followerLevel == 9) {
				initStrTouSpeInte(330, 380, 430, 120);
				initWisLibSensCor(120, 100, 50, 50);
				this.weaponAttack = 93;
				this.armorDef = 133;
				this.armorMDef = 133;
				this.bonusHP = 4900;
				this.bonusLust = 199;
				this.level = 49;
			}
			if (followerLevel == 10) {
				initStrTouSpeInte(333, 386, 439, 121);
				initWisLibSensCor(128, 115, 54, 50);
				this.weaponAttack = 97;
				this.armorDef = 135;
				this.armorMDef = 135;
				this.bonusHP = 5000;
				this.bonusLust = 224;
				this.bonusWrath = 100;
				this.bonusSoulforce = 400;
				this.level = 55;
			}
			if (followerLevel == 11) {
				initStrTouSpeInte(336, 392, 448, 122);
				initWisLibSensCor(136, 130, 58, 50);
				this.weaponAttack = 101;
				this.armorDef = 137;
				this.armorMDef = 137;
				this.bonusHP = 5100;
				this.bonusLust = 249;
				this.bonusWrath = 200;
				this.bonusSoulforce = 800;
				this.level = 61;
			}
			if (followerLevel == 12) {
				initStrTouSpeInte(339, 398, 457, 123);
				initWisLibSensCor(144, 145, 62, 50);
				this.weaponAttack = 105;
				this.armorDef = 139;
				this.armorMDef = 139;
				this.bonusHP = 5200;
				this.bonusLust = 274;
				this.bonusWrath = 300;
				this.bonusSoulforce = 1200;
				this.level = 67;
			}
			if (followerLevel == 13) {
				initStrTouSpeInte(342, 404, 466, 124);
				initWisLibSensCor(152, 160, 66, 50);
				this.weaponAttack = 109;
				this.armorDef = 141;
				this.armorMDef = 141;
				this.bonusHP = 5300;
				this.bonusLust = 299;
				this.bonusWrath = 400;
				this.bonusSoulforce = 1600;
				this.level = 73;
			}
    }

    override public function setPerks():void {
        if (followerLevel >= 2) {
				this.createPerk(PerkLib.SoulApprentice, 0, 0, 0, 0);
				this.createPerk(PerkLib.ToughHide, 0, 0, 0, 0);
				this.createPerk(PerkLib.Resolute, 0, 0, 0, 0);
				this.createPerk(PerkLib.RefinedBodyI, 0, 0, 0, 0);
				this.createPerk(PerkLib.BasicTranquilness, 0, 0, 0, 0);
				this.createPerk(PerkLib.BasicSelfControl, 0, 0, 0, 0);
			}
			if (followerLevel >= 3) {
				this.createPerk(PerkLib.InhumanDesireI, 0, 0, 0, 0);
				this.createPerk(PerkLib.WeaponClawsClawTraining, 0, 0, 0, 0);
				this.createPerk(PerkLib.TankI, 0, 0, 0, 0);
			}
			if (followerLevel >= 4) {
				this.createPerk(PerkLib.SoulPersonage, 0, 0, 0, 0);
				this.createPerk(PerkLib.FeralArmor, 0, 0, 0, 0);
				this.createPerk(PerkLib.HalfStepToImprovedSelfControl, 0, 0, 0, 0);
			}
			if (followerLevel >= 5) {//lvl 25
				this.createPerk(PerkLib.SoulWarrior, 0, 0, 0, 0);
				this.createPerk(PerkLib.WeaponClawsExtraClawAttack, 0, 0, 0, 0);
				this.createPerk(PerkLib.GoliathI, 0, 0, 0, 0);
			}
			if (followerLevel >= 6) {//lvl 31
				this.createPerk(PerkLib.HclassHeavenTribulationSurvivor, 0, 0, 0, 0);
				this.createPerk(PerkLib.SoulSprite, 0, 0, 0, 0);
				this.createPerk(PerkLib.FleshBodyWarriorStage, 0, 0, 0, 0);
			}
			if (followerLevel >= 7) {//lvl 37
				this.createPerk(PerkLib.EpicToughness, 0, 0, 0, 0);
				this.createPerk(PerkLib.WeaponClawsMultiClawAttack, 0, 0, 0, 0);
				this.createPerk(PerkLib.DemonicDesireI, 0, 0, 0, 0);
			}
			if (followerLevel >= 8) {//lvl 43
				this.createPerk(PerkLib.SoulScholar, 0, 0, 0, 0);
				this.createPerk(PerkLib.CheetahI, 0, 0, 0, 0);
				this.createPerk(PerkLib.ImprovedSelfControl, 0, 0, 0, 0);
			}
			if (followerLevel >= 9) {//lvl 49
				this.createPerk(PerkLib.SoulGrandmaster, 0, 0, 0, 0);
				this.createPerk(PerkLib.WeaponClawsClawingFlurry, 0, 0, 0, 0);
				this.createPerk(PerkLib.EpicSpeed, 0, 0, 0, 0);
			}
			if (followerLevel >= 10) {//lvl 55
				this.createPerk(PerkLib.GclassHeavenTribulationSurvivor, 0, 0, 0, 0);
				this.createPerk(PerkLib.SoulElder, 0, 0, 0, 0);
				this.createPerk(PerkLib.FleshBodyElderStage, 0, 0, 0, 0);
			}
			if (followerLevel >= 11) {//lvl 61
				this.createPerk(PerkLib.EpicStrength, 0, 0, 0, 0);
				this.createPerk(PerkLib.HalfStepToAdvancedSelfControl, 0, 0, 0, 0);
			}
			if (followerLevel >= 12) {//lvl 67
				this.createPerk(PerkLib.SoulExalt, 0, 0, 0, 0);
				this.createPerk(PerkLib.EpicLibido, 0, 0, 0, 0);
			}
			if (followerLevel >= 13) {//lvl 73
				this.createPerk(PerkLib.SoulOverlord, 0, 0, 0, 0);
				this.createPerk(PerkLib.AdvancedSelfControl, 0, 0, 0, 0);
			}
    }

    

    override public function prepareActions():Array {
        var abilities:Array = super.prepareActions();
        var weights:Array = generateWeights();
            
        abilities.push(
            { call: basicAttack, type: ABILITY_PHYSICAL, range: RANGE_MELEE, weight: weights[0] },
            { call: defendPlayer, type: ABILITY_SPECIAL, range: RANGE_SELF, condition: defendCondition, weight: weights[1] },
            { call: tripleThrustAttack, type: ABILITY_PHYSICAL, range: RANGE_RANGED, weight: weights[2] },
            { call: stunAttack, type: ABILITY_SPECIAL, range: RANGE_MELEE, condition: stunCondition, weight: weights[3] }
        );

        return abilities;
    }

    override public function readyAction(monster:Monster, display:Boolean = true):void {
        if (display) outputText("Aurora assumes a combat stance.\n\n");
        super.readyAction(monster, display);
    }

    override public function standBy(monster:Monster, display:Boolean = true):void {
			if (display) outputText("Aurora looks for an opening in the battle.\n\n");
    }

    override public function standByWeight():int {
        if (player.hasPerk(PerkLib.MotivationEx)) {
            return 0;
        } else if (player.hasPerk(PerkLib.Motivation)) {
            return 4;
        } else {
            return 10;
        }
    }

    public function basicAttack(monster:Monster, display:Boolean = true):void {
        var dmg1:Number = this.str;
        var weaponAurora:Number = this.weaponAttack;

        dmg1 += eBaseDamage();
        dmg1 = functions.scalingWeapon(weaponAurora, dmg1);
        dmg1 *= functions.increasedEfficiencyOfAttacks();
        dmg1 = functions.taticianBonus(dmg1);

        if (display) outputText("Aurora strikes at [themonster] with her fists. ");
        functions.doDamageFollower(this, dmg1, true, display);
        if (display) outputText("\n\n");
    }

    private function defendCondition():Boolean {
        return !player.hasStatusEffect(StatusEffects.CompBoostingPCArmorValue);
    }

    public function defendPlayer(monster:Monster, display:Boolean = true):void {
        if (display) outputText("Aurora moves in front of you, deflecting the opponent's attacks with her body in order to assist your own defence.\n\n");
        player.createStatusEffect(StatusEffects.CompBoostingPCArmorValue, 0, 0, 0, 0);
    }

    private function stunCondition():Boolean {
        return !CoC.instance.monster.hasStatusEffect(StatusEffects.Stunned);
    }

    public function tripleThrustAttack(monster:Monster, display:Boolean = true):void {
        var dmg1:Number = this.str;
        var weaponAurora:Number = this.weaponAttack;

        dmg1 += eBaseStrengthDamage();
        dmg1 = functions.scalingWeapon(weaponAurora, dmg1);
        dmg1 *= functions.increasedEfficiencyOfAttacks();
        dmg1 = functions.taticianBonus(dmg1);

        if (display) outputText("Aurora thrusts her hand at [themonster]. Her claws hit thrice against [themonster], dealing ");
		functions.doDamageFollower(this, dmg1, true, display);
        functions.doDamageFollower(this, dmg1, true, display);
        functions.doDamageFollower(this, dmg1, true, display);
		if (display) outputText(" damage!\n\n");
    }

    public function stunAttack(monster:Monster, display:Boolean = true):void {
        var dmg3a:Number = (eBaseStrengthDamage() + eBaseToughnessDamage()) / 6;
        dmg3a = Math.round(dmg3a * functions.increasedEfficiencyOfAttacks());
        if (display) outputText("Aurora flaps her huge bat wings at [themonster] trying to knock it down. ");
        functions.doDamageFollower(this, dmg1, true, display);
        if (!monster.hasPerk(PerkLib.Resolute)) {
            monster.createStatusEffect(StatusEffects.Stunned, 1, 0, 0, 0);
            if (display) outputText("\n\n");
        } else {
            if (display) outputText("However, [themonster] was able to stand their ground.\n\n");
        }
    }

    public function generateWeights():Array {
        if (player.hasPerk(PerkLib.MotivationEx)) {
            return [5, 5, 5, 5];
        } else if (player.hasPerk(PerkLib.Motivation)) {
            return [7, 4, 3, 2];
        } else {
            return [3, 3, 2, 2];
        }
    }
}
}