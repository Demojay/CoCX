/**
 * Original code by aimozg on 27.01.14.
 * Extended for Mutations by Jtecx on 14.03.22.
 */
package classes.IMutations
{
import classes.BodyParts.Tail;
import classes.PerkClass;
import classes.PerkLib;
import classes.IMutationPerkType;
import classes.Creature;
import classes.Player;
import classes.Races;

public class StillHeartMutation extends IMutationPerkType
    {
        override public function get mName():String {
            return "Still Heart";
        }
		
		public function StillHeartMutation() 
		{
			super(mName + " IM", mName, SLOT_NONE, 1);
		}
        
    }
}
