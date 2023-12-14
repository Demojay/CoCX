package classes.Scenes.Combat {

import classes.StatusEffectType;
import classes.PerkType;
import classes.Races;
import classes.CoC;

public class AbstractSpecial extends CombatAbility {
    protected var knownCondition:*;
    public var affectsInvisible:Boolean = false;
    public static var USE_BOTH:int = 0;
    public static var FLIGHT_ONLY:int = 1;
    public static var LAND_ONLY:int = 2;
    public var abilityAvailable:int;


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
            useMana(finalManaCost);
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
}
}
