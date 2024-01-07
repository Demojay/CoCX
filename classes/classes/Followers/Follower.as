package classes.Followers {
import classes.Monster;
import classes.PerkLib;
import classes.CoC;
import classes.StatusEffectType;
import classes.StatusEffects;
import classes.Scenes.SceneLib;

public class Follower extends Monster {

    public static var functions:FollowerFunctions = new FollowerFunctions();
    protected static var followerManager:FollowerManager = SceneLib.followerManager;
    public var ready:Boolean = false;
    public var levelCap:int;
    protected var followerLevel:int;
    protected var defeats:int;
    public var timerStatusEffect:StatusEffectType;
    public var timerStatusPosition:int;


    public function Follower() { }

    public function setStats():void { }

    public function setPerks():void { }

    public function setInitialPerks():void { }
    
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

    public function readyAction(monster:Monster, display:Boolean = true):void { ready = true; }

    public function standBy(monster:Monster, display:Boolean = true):void { }

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
        var monster:Monster = CoC.instance.monster;
        var attacks:int = (player.hasPerk(PerkLib.MotivationSu))? 2: 1;

        for(var index:int = 0; index < attacks; index++)
        {
            if (ready && player.hasPerk(PerkLib.MotivationEx) && rand(100) == 0) {
                standBy(monster, display);
            } else {
                var roll:Object = pickRandomAbility(abilities, monster);
                if (!roll) {
                    if (display) standBy(monster, display);
                    return;
                }
                roll.call(monster, display);
            }
        }
        monster.postCompanionAction();
    }

    //Call from the clearstatuses function in the player class
    public function clearStatuses():void {
        ready = false;
    }
    
}
}