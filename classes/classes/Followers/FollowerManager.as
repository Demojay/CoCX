package classes.Followers {

import classes.BaseContent;
import classes.internals.SaveableState;
import classes.Saves;
import classes.CoC;

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
    }

    public function saveToObject():Object
    {
    	return {
            "follower0Name": _follower0Name,
            "follower1Name": _follower1Name,
            "follower2Name": _follower2Name,
            "follower3Name": _follower3Name
        }
    }

    public function loadFromObject(o:Object, ignoreErrors:Boolean):void
    {
    	if(o) {
            _follower0Name = o.follower0Name;
            _follower1Name = o.follower1Name;
            _follower2Name = o.follower2Name;
            _follower3Name = o.follower3Name;
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

    private var _follower0Name:String = "";
    private var _follower1Name:String = FOLLOWER_NEISA;
    private var _follower2Name:String = "";
    private var _follower3Name:String = "";

    private var followerAttacked:Array = [];

    private var neisaCompanion:Follower = new NeisaCompanion();

    public var followers:Object = {
        "Neisa": neisaCompanion
    }

    public function FollowerManager() {
        //Saves.registerSaveableState(this);
        followerAttacked = [0,0,0,0];
    }

    public function getFollower(position:int):Follower {
        if (position < 0 || position > 3) {
            throw new Error("Invalid follower position entered");
        } else {
            var followerName:String = getFollowerName(position);
            return followers[followerName];
        }
    }

    public function getFollowerName(position:int):String {
        switch (position) {
            case 0: return _follower0Name;
                    break;
            case 1: return _follower1Name;
                    break;
            case 2: return _follower2Name;
                    break;
            case 3: return _follower3Name;
                    break;
            default: throw new Error("Invalid follower positon entered");
        }
    }

    public function setFollower(position:int, follower:String):void {
        if (position < 0 || position > 3) {
            throw new Error("Invalid follower positon entered");
        } else if (!followers.hasOwnProperty(follower)) {
            throw new Error("Follower attempted to set was invalid");
        } else {
            switch(position) {
                case 0: _follower0Name = follower;
                        break;
                case 1: _follower1Name = follower;
                        break;
                case 2: _follower2Name = follower;
                        break;
                case 3: _follower3Name = follower;
                        break;
            }
        }
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
            if (getFollowerName(pos))
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

        if (!getFollowerName(position)) {
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
        
        return getFollowerName(position) && followerAttacked[position] == 0;
    }

    
}
}