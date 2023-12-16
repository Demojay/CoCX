package classes.Scenes.Combat {

import classes.StatusEffectType;
import classes.PerkType;
import classes.Races;
import classes.CoC;
import classes.VaginaClass;
import classes.Monster;

public class AbstractSpecial extends CombatAbility {
    protected var knownCondition:*;
    public var affectsInvisible:Boolean = false;
    public static var USE_BOTH:int = 0;
    public static var FLIGHT_ONLY:int = 1;
    public static var LAND_ONLY:int = 2;
    public var abilityAvailable:int;
    public var manaType:int = Combat.USEMANA_NORMAL;


    public function AbstractSpecial (
            name:String,
            desc:String,
            targetType:int,
            timingType:int,
            tags:/*int*/Array,
            knownCondition:*
    ) {
        super(name, desc, targetType, timingType, tags);
        this.knownCondition = knownCondition;
        this.abilityAvailable = USE_BOTH;
    }

    override public function get isKnown():Boolean {
        var condition:Boolean = false;

        if (knownCondition is StatusEffectType)
            condition = player.hasStatusEffect(knownCondition);
        if (knownCondition is PerkType)
            condition =  player.hasPerk(knownCondition);
        if (knownCondition is Races)
            condition =  player.isRaceCached(knownCondition);

        //Ability is known depending on whether the user is flying in combat and the ability configuration
        if (CoC.instance.inCombat && ((player.isFlying() && abilityAvailable == LAND_ONLY) || (!player.isFlying() && abilityAvailable == FLIGHT_ONLY)))
            condition = false;

        return condition;
    }

    override public function useResources():void {
        super.useResources();

        var finalManaCost:Number = manaCost();
        var finalFatigueCost:Number = fatigueCost();
        var finalSFCost:Number = sfCost();
        var finalWrathCost:Number = wrathCost();

        if (finalManaCost > 0) {
            useMana(finalManaCost, manaType);
        }

        if (finalFatigueCost > 0) {
            fatigue(finalFatigueCost);
        }

        if (finalSFCost > 0) {
            player.soulforce -= finalSFCost;
        }

        if (finalWrathCost > 0) {
            player.wrath -= finalWrathCost;
        }   
    }

    override protected function usabilityCheck():String {
        // Run all check applicable to all abilities
		var uc:String = super.usabilityCheck();
		if (uc) return uc;

        if (player.fatigueLeft() < fatigueCost()) {
			return "You are too tired to use this ability."
		}

        if (player.mana < manaCost()) {
			return "Your mana is too low to use this ability."
		}

        if (player.soulforce < sfCost()) {
			return "Your soulforce is too low to use this ability."
		}

        if (player.wrath < wrathCost()) {
			return "Your wrath is too low to use this ability!"
		}

        if (!affectsInvisible && targetType == TARGET_ENEMY && combat.isEnemyInvisible) {
            return "You cannot use offensive skills against an opponent you cannot see or target."
        }

        return "";
    }

    protected function sfCostMod(sfCost:Number):int {
        return Math.round(sfCost * soulskillCost() * soulskillcostmulti());
    }

    protected function mosterTeaseText(monster:Monster):void {
		if (monster.cocks.length > 0) {
			if (monster.lust >= (monster.maxLust() * 0.6)) outputText("You see [monster his] [monster cocks] dribble pre-cum.  ");
			else if (monster.lust >= (monster.maxLust() * 0.3) && monster.cocks.length == 1) outputText("[Themonster]'s [monster cock] hardens, distracting [monster him] further.  ");
			else if (monster.lust >= (monster.maxLust() * 0.3)) outputText("You see [monster his] [monster cocks] harden uncomfortably.  ");
		}
		if (monster.vaginas.length > 0) {
			if (monster.plural) {
				if (monster.lust >= (monster.maxLust() * 0.6)) {
					if (monster.vaginas[0].vaginalWetness == VaginaClass.WETNESS_NORMAL) outputText("[Themonster]'s [monster vag]s dampen perceptibly.  ");
					if (monster.vaginas[0].vaginalWetness == VaginaClass.WETNESS_WET) outputText("[Themonster]'s crotches become sticky with girl-lust.  ");
					if (monster.vaginas[0].vaginalWetness == VaginaClass.WETNESS_SLICK) outputText("[Themonster]'s [monster vag]s become sloppy and wet.  ");
					if (monster.vaginas[0].vaginalWetness == VaginaClass.WETNESS_DROOLING) outputText("Thick runners of girl-lube stream down the insides of [themonster]'s thighs.  ");
					if (monster.vaginas[0].vaginalWetness == VaginaClass.WETNESS_SLAVERING) outputText("[Themonster]'s [monster vag]s instantly soak [monster him] groin.  ");
				}
			} else {
				if (monster.lust >= (monster.maxLust() * 0.6)) {
					if (monster.vaginas[0].vaginalWetness == VaginaClass.WETNESS_NORMAL) outputText("[Themonster]'s [monster vag] dampens perceptibly.  ");
					if (monster.vaginas[0].vaginalWetness == VaginaClass.WETNESS_WET) outputText("[Themonster]'s crotch becomes sticky with girl-lust.  ");
					if (monster.vaginas[0].vaginalWetness == VaginaClass.WETNESS_SLICK) outputText("[Themonster]'s [monster vag] becomes sloppy and wet.  ");
					if (monster.vaginas[0].vaginalWetness == VaginaClass.WETNESS_DROOLING) outputText("Thick runners of girl-lube stream down the insides of [themonster]'s thighs.  ");
					if (monster.vaginas[0].vaginalWetness == VaginaClass.WETNESS_SLAVERING) outputText("[Themonster]'s [monster vag] instantly soaks her groin.  ");
				}
			}
		}
	}
}
}
