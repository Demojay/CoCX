package classes.Followers {

import classes.BaseContent;
import classes.internals.SaveableState;
import classes.Saves;
import classes.CoC;
import classes.Scenes.NPCs.Neisa;
import classes.Scenes.NPCs.Kiha;
import classes.StatusEffects;
import classes.Scenes.NPCs.Aurora;

public class FollowerManager extends BaseContent implements SaveableState {

    public function stateObjectName():String
    {
    	return "FollowerManager";
    }

    public function resetState():void
    {
    	_follower0Name = "";
        _follower1Name = "";
        _follower2Name = "";
        _follower3Name = "";
        followerLevels = {};
        for each (var follower:String in followerArray) {
            followerLevels[follower] = {
                "name": follower,
                "level": 1,
                "defeats": 1
            }
        }
    }

    public function saveToObject():Object
    {
    	return {
            "follower0Name": _follower0Name,
            "follower1Name": _follower1Name,
            "follower2Name": _follower2Name,
            "follower3Name": _follower3Name,
            "followerLevels": followerLevels
        }
    }

    public function loadFromObject(o:Object, ignoreErrors:Boolean):void
    {
    	if(o) {
            _follower0Name = o.follower0Name;
            _follower1Name = o.follower1Name;
            _follower2Name = o.follower2Name;
            _follower3Name = o.follower3Name;
            followerLevels = o.followerLevels;
        } else  {
            resetState();
        }
    }
    
    public static var FOLLOWER_ALVINA:String = "Alvina";
    public static var FOLLOWER_AMILY:String = "Amily";
    public static var FOLLOWER_AURORA:String = "Aurora";
    public static var FOLLOWER_ETNA:String = "Etna";
    public static var FOLLOWER_EXCELLIA:String = "Excellia";
    public static var FOLLOWER_GHOUL:String = "Helia";
    public static var FOLLOWER_KIHA:String = "Kiha";
    public static var FOLLOWER_MIDOKA:String = "Midoka";
    public static var FOLLOWER_MITZI:String = "Mitzi";
    public static var FOLLOWER_NEISA:String = "Neisa";
    public static var FOLLOWER_TYRANTIA:String = "Tyrantia";
    public static var FOLLOWER_ZENJI:String = "Zenji";
    private static var followerArray:Array = [
        FOLLOWER_ALVINA,
        FOLLOWER_AMILY,
        FOLLOWER_AURORA,
        FOLLOWER_ETNA,
        FOLLOWER_EXCELLIA,
        FOLLOWER_GHOUL,
        FOLLOWER_KIHA,
        FOLLOWER_MIDOKA,
        FOLLOWER_MITZI,
        FOLLOWER_NEISA,
        FOLLOWER_TYRANTIA,
        FOLLOWER_ZENJI
    ];

    private var _follower0Name:String = "";
    private var _follower1Name:String = "";
    private var _follower2Name:String = "";
    private var _follower3Name:String = "";

    private var _follower0:Follower;
    private var _follower1:Follower;
    private var _follower2:Follower;
    private var _follower3:Follower;

    public var followerLevels:Object = {};

    private var followerAttacked:Array;

    public var followers:/*Follower*/Object = {
        "Neisa": Neisa,
        "Kiha": Kiha,
        "Aurora": Aurora
    }

    public function FollowerManager() {
        Saves.registerSaveableState(this);
        followerAttacked = [0,0,0,0];
    }

    public function getFollower(position:int):Follower {
        if (hasFollowerInPosition(position)) {
            switch (position) {
                case 0: if (_follower0)
                            return _follower0
                        else
                            return _follower0 = new followers[follower0Name]();
                        break;
                case 1: if (_follower1)
                            return _follower1
                        else
                            return _follower1 = new followers[follower1Name]();
                        break;
                case 2: if (_follower2)
                            return _follower2
                        else
                            return _follower2 = new followers[follower2Name]();
                        break;
                case 3: if (_follower3)
                            return _follower3
                        else
                            return _follower3 = new followers[follower3Name]();
                        break;
            }
        } 
        return null;
    }

    public function get follower0Name():String {
        return _follower0Name;
    }

    public function set follower0Name(follower:String):void {
        if (followerArray.indexOf(follower) > -1) {
            _follower0Name = follower;
        }
    }

    public function get follower1Name():String {
        return _follower1Name;
    }

    public function set follower1Name(follower:String):void {
        if (followerArray.indexOf(follower) > -1) {
            _follower1Name = follower;
        }
    }

    public function get follower2Name():String {
        return _follower2Name;
    }

    public function set follower2Name(follower:String):void {
        if (followerArray.indexOf(follower) > -1) {
            _follower2Name = follower;
        }
    }

    public function get follower3Name():String {
        return _follower3Name;
    }

    public function set follower3Name(follower:String):void {
        if (followerArray.indexOf(follower) > -1) {
            _follower3Name = follower;
        }
    }


    public function hasFollowerInPosition(position:int):Boolean {
        switch (position) {
            case 0: return follower0Name != "";
                    break;
            case 1: return follower1Name != "";
                    break;
            case 2: return follower2Name != "";
                    break;
            case 3: return follower3Name != "";
                    break;
        }
        return false;
    }

    public function resetFollowerAttacks():void {
        followerAttacked = [0,0,0,0];
    }

    public function hasFollowerAttacked(position:int):Boolean { return followerAttacked[position]; }
    public function setFollowerAttacked(position:int):void { followerAttacked[position] = 1; }

    public function getFollowerPosition(follower:String):int {
        if (_follower1Name == follower) return 1;
        else if (_follower2Name == follower) return 2;
        else if (_follower3Name == follower) return 3;
        else if (_follower0Name == follower) return 0;
        else return -1;
    }

    public function prepareForCombat():void {
        for(var pos:int = 0; pos < 4; pos++) {
            if (hasFollowerInPosition(pos))
                getFollower(pos).clearStatuses();
        }
    }

    public function performAttack(position:int, display:Boolean = true):Boolean {
        if (!CoC.instance.inCombat) {
            trace("Perform Attack function called when outside of combat")
            return false;
        }

        if (position < 0 || position > 3) {
            trace("Invalid follower position given to performAttack function");
            return false;
        }

        if (!hasFollowerInPosition(position)) {
            trace("Perform Attack called on empty position")
            return false;
        }

        var followerToAttack:Follower = getFollower(position);
        followerToAttack.performCompanionAction(display);
        followerAttacked[position] = 1;
        return true;
    }

    public function canAttack(position:int):Boolean {
        if (!CoC.instance.inCombat) {
            trace("Can Attack function called when outside of combat")
            return false;
        }

        if (position < 0 || position > 3) {
            trace("Invalid follower position given to canAttack function");
            return false;
        }
        
        return hasFollowerInPosition(position) && followerAttacked[position] == 0 && !(player.hasStatusEffect(StatusEffects.MinoKing) && player.statusEffectv1(StatusEffects.MinoKing) == position);
    }

    public function levelUpCheck(followerName:String, exp:int = 1):void {
        var levelObj:Object = followerLevels[followerName];

        if (!levelObj) {
            trace("Error - could not find follower level up object for " + followerName);
            return;
        }

        var follower:Follower = followers[followerName];
        levelObj.defeats += exp;
        
        if (levelObj.defeats >= levelObj.level && levelObj.level < follower.levelCap) {
            if (player.hasStatusEffect(follower.timerStatusEffect)) player.addStatusValue(follower.timerStatusEffect, follower.timerStatusPosition, player.statusEffectv1(StatusEffects.TrainingNPCsTimersReduction));
            else player.createOrAddStatusEffect(follower.timerStatusEffect, follower.timerStatusPosition, player.statusEffectv1(StatusEffects.TrainingNPCsTimersReduction));
            levelObj.defeats = 0;
            levelObj.level++;
	    }
    }

    
}
}