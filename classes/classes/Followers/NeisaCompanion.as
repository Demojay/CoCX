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

public class NeisaCompanion extends Follower implements SaveableState{

    public function NeisaCompanion() { 
        Saves.registerSaveableState(this);
        levelCap = 11;
        timerStatusEffect = StatusEffects.CampSparingNpcsTimers4;
        timerStatusPosition = 4;
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
    	return "NeisaCompanion";
    }

    private function setUp():void {
        this.a = "";
        this.short = "Neisa";
        this.imageName = "Neisa";
        this.long = "Neisa is a seven foot tall, raven-haired shield maiden. Her full plate armor and giant shield makes it hard to have a good look at her. And if you would try to peek at her you have to be vary of her bastard sword that may swing your way.";
        // this.plural = false;
        this.createVagina(false, VaginaClass.WETNESS_WET, VaginaClass.LOOSENESS_NORMAL);
        this.createStatusEffect(StatusEffects.BonusVCapacity, 45, 0, 0, 0);
        createBreastRow(Appearance.breastCupInverse("I"));
        this.ass.analLooseness = AssClass.LOOSENESS_VIRGIN;
        this.ass.analWetness = AssClass.WETNESS_DRY;
        this.createStatusEffect(StatusEffects.BonusACapacity,38,0,0,0);
        this.tallness = 7*12+6;
        this.hips.type = Hips.RATING_CURVY + 2;
        this.butt.type = Butt.RATING_LARGE + 1;
        this.bodyColor = "dusky";
        this.hairColor = "red";
        this.hairLength = 13;
        this.weaponName = "bastard sword and giant shield";
        this.weaponVerb="slash";
        this.armorName = "heavy plate armor";
        this.armorPerk = "";
        this.armorValue = 70;
        this.lust = 30;
        this.lustVuln = .35;
        this.gems = rand(10) + 25;
        this.drop = NO_DROP;
        IMutationsLib.DraconicLungIM.acquireMutation(this, "none", 1);
        IMutationsLib.OniMusculatureIM.acquireMutation(this, "none", 1);
        IMutationsLib.PigBoarFatIM.acquireMutation(this, "none", 1);
        IMutationsLib.OrcAdrenalGlandsIM.acquireMutation(this, "none", 1);
        IMutationsLib.LizanMarrowIM.acquireMutation(this, "none", 1);
        
        setInitialPerks();
        setStats();
        setPerks();
        checkMonster();
        prepareForCombat();
    }

    override public function setInitialPerks():void {
        this.createPerk(PerkLib.JobGuardian, 0, 0, 0, 0);
        this.createPerk(PerkLib.ShieldWielder, 0, 0, 0, 0);
        this.createPerk(PerkLib.Ferocity, 0, 0, 0, 0);
        this.createPerk(PerkLib.LizanRegeneration, 0, 0, 0, 0);
    }

    override public function setStats():void {
        var mod:int = (followerLevel - 1);
        initStrTouSpeInte(50 + 15*mod, 80 + 22*mod, 50 + 10*mod, 44 + 8*mod);
        initWisLibSensCor(44 + 8*mod, 52 + 6*mod, 25 + 5*mod, 50);
        this.weaponAttack = 12 + 3*mod;
        this.armorDef = 0 + 8*mod;
        this.armorMDef = 0 + 2*mod;
        this.bonusHP = 200 + 200*mod;
        this.bonusLust = 80 + 17*mod;
        this.level = 3 + 6*mod;
    }

    override public function setPerks():void {
        if (level >= 2) {
				this.createPerk(PerkLib.Diehard, 0, 0, 0, 0);
				this.createPerk(PerkLib.TankI, 0, 0, 0, 0);
			}
        if (level >= 3) {
            this.createPerk(PerkLib.JobKnight, 0, 0, 0, 0);
            this.createPerk(PerkLib.Regeneration, 0, 0, 0, 0);
            this.createPerk(PerkLib.Resolute, 0, 0, 0, 0);
        }
        if (level >= 4) {
            this.createPerk(PerkLib.ImprovedDiehard, 0, 0, 0, 0);
            this.createPerk(PerkLib.RefinedBodyI, 0, 0, 0, 0);
            this.createPerk(PerkLib.ImmovableObject, 0, 0, 0, 0);
        }
        if (level >= 5) {
            this.createPerk(PerkLib.JobDefender, 0, 0, 0, 0);
            this.createPerk(PerkLib.Juggernaut, 0, 0, 0, 0);
            this.createPerk(PerkLib.GoliathI, 0, 0, 0, 0);
        }
        if (level >= 6) {
            IMutationsLib.CatLikeNimblenessIM.acquireMutation(this, "none", 2);
            IMutationsLib.GorgonEyesIM.acquireMutation(this, "none", 2);
            this.createPerk(PerkLib.GreaterDiehard, 0, 0, 0, 0);
        }
        if (level >= 7) {
            IMutationsLib.DraconicLungIM.acquireMutation(this, "none");
            IMutationsLib.LizanMarrowIM.acquireMutation(this, "none");
            this.createPerk(PerkLib.CheetahI, 0, 0, 0, 0);
        }
        if (level >= 8) {
            IMutationsLib.OniMusculatureIM.acquireMutation(this, "none");
            IMutationsLib.OrcAdrenalGlandsIM.acquireMutation(this, "none");
            this.createPerk(PerkLib.EpicDiehard, 0, 0, 0, 0);
        }
        if (level >= 9) {
            IMutationsLib.LactaBovinaOvariesIM.acquireMutation(this, "none", 2);
            IMutationsLib.PigBoarFatIM.acquireMutation(this, "none");
        }
        if (level >= 10) {
            this.createPerk(PerkLib.EpicToughness, 0, 0, 0, 0);
            this.createPerk(PerkLib.EpicStrength, 0, 0, 0, 0);
        }
        if (level >= 11) {
            IMutationsLib.DraconicLungIM.acquireMutation(this, "none");
            IMutationsLib.OniMusculatureIM.acquireMutation(this, "none");
            IMutationsLib.OrcAdrenalGlandsIM.acquireMutation(this, "none");
            IMutationsLib.PigBoarFatIM.acquireMutation(this, "none");
        }
    }

    override public function prepareActions():Array {
        var abilities:Array = super.prepareActions();
        var weights:Array = generateWeights();
            
        abilities.push(
            { call: basicAttack, type: ABILITY_PHYSICAL, range: RANGE_MELEE, weight: weights[0] },
            { call: defendPlayer, type: ABILITY_SPECIAL, range: RANGE_SELF, condition: defendCondition, weight: weights[1] },
            { call: stunAttack, type: ABILITY_SPECIAL, range: RANGE_MELEE, condition: stunCondition, weight: weights[2] },
            { call: powerStunAttack, type: ABILITY_SPECIAL, range: RANGE_MELEE, condition: stunCondition, weight: weights[3] }
        );

        return abilities;
    }

    override public function readyAction(monster:Monster, display:Boolean = true):void {
        if (display) outputText("Neisa steps forward, shield at the ready in order to defend you.\n\n");
        super.readyAction(monster, display);
    }

    override public function standBy(monster:Monster, display:Boolean = true):void {
			if (display) outputText("Neisa looks for an opening in the battle.\n\n");
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
        var weaponNeisa:Number = this.weaponAttack;

        dmg1 += eBaseDamage();
        dmg1 = functions.scalingWeapon(weaponNeisa, dmg1);
        dmg1 *= functions.increasedEfficiencyOfAttacks();
        dmg1 = functions.taticianBonus(dmg1);

        if (display) outputText("Neisa slashes at [themonster] with her sword. ");
        functions.doDamageFollower(this, dmg1, true, display);
        if (display) outputText("\n\n");
    }

    private function defendCondition():Boolean {
        return !player.hasStatusEffect(StatusEffects.CompBoostingPCArmorValue);
    }

    public function defendPlayer(monster:Monster, display:Boolean = true):void {
        if (display) outputText("Neisa moves in front of you, deflecting the opponent’s attacks with her shield in order to assist your own defence.\n\n");
        player.createStatusEffect(StatusEffects.CompBoostingPCArmorValue, 0, 0, 0, 0);
    }

    private function stunCondition():Boolean {
        return !CoC.instance.monster.hasStatusEffect(StatusEffects.Stunned);
    }

    public function stunAttack(monster:Monster, display:Boolean = true):void {
        if (display) outputText("Neisa smashes her shield on [themonster]’s head, ");
        if (!monster.hasPerk(PerkLib.Resolute)) {
            monster.createStatusEffect(StatusEffects.Stunned, 1, 0, 0, 0);
            if (display) outputText("stunning it.\n\n");
        } else {
            if (display) outputText("but the enemy endured it.\n\n");
        }
    }

    public function powerStunAttack(monster:Monster, display:Boolean = true):void {
        if (display) outputText("Neisa viciously rams her shield on [themonster], ");
        if (!monster.hasPerk(PerkLib.Resolute)) {
            monster.createStatusEffect(StatusEffects.Stunned, 2, 0, 0, 0);
            if (display) outputText("dazing it.\n\n");
        } else {
            if (display) outputText("but the enemy endured it.\n\n");
        }
    }

    public function generateWeights():Array {
        if (player.hasPerk(PerkLib.MotivationEx)) {
            return [5, 5, 5, 5];
        } else if (player.hasPerk(PerkLib.Motivation)) {
            return [7, 5, 3, 1];
        } else {
            return [4, 3, 2, 1];
        }
    }
}
}