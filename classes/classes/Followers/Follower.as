package classes.Followers {
import classes.Monster;
import classes.PerkLib;

public class Follower extends Monster {

    public static var functions:FollowerFunctions = new FollowerFunctions();
    public var ready:Boolean = false;
    protected var levelCap:int = 8;

    public function Follower() { }

    public function setStats():void { }

    public function setPerks():void { }

    public function setInitialPerks():void { }

    public function clearStatuses():void { }

    public function prepareActions():Array { 
        var abilities:Array = [];

        abilities.push({
            call: readyAction,
            type: ABILITY_SPECIAL,
            range: RANGE_SELF,
            condition: function():Boolean { return !ready; },
            weight: Infinity
        });
        

        if (!player.hasPerk(PerkLib.MotivationEx)) {
            abilities.push({ call: standBy, type: ABILITY_SPECIAL, range: RANGE_SELF, weight: standByWeight() });
        }

        return abilities; 
    }

    public function readyAction():void { ready = true; }

    public function standBy(display:Boolean = true):void { }

    public function standByWeight():int { return 0; }

    public function reset():void {
        ready = false;
        setStats();
        removePerks();
        setInitialPerks();
        clearStatuses();
        setPerks();
        checkMonster();
        prepareForCombat();
     }

     public function performCompanionAction(display:Boolean = true):void {
        var abilities:Array = prepareActions();

        if (ready && player.hasPerk(PerkLib.MotivationEx) && rand(100) == 0) {
            standBy(display);
        } else {
            var roll:Object = pickRandomAbility(abilities, functions.monster);
            if (!roll) {
                if (display) standBy(display);
                return;
            }
            roll.call(display);
        }

        
    }


    
}
}