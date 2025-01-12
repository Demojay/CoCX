package classes.Items.WeaponsRange 
{
	import classes.Items.WeaponRange;
	import classes.Player;
	
	/**
	 * ...
	 * @author Oxdeception
	 */
	public class WildHunt extends WeaponRange
	{
		
		public function WildHunt() 
		{
			super("WildHunt", "Wild Hunt", "wild hunt longbow", "wild hunt longbow", "shot", 130, 6500,
					"The ebony wood of this corrupt bow seems to ignore light. Arrows fired with this weapon seem to have a malignant mind of their own, striking down the weak with brutal efficiency.",
					"Bow"
			);
		}
		override public function get attack():Number{
			var boost:int = 0;
			var scal:Number = 5;
			if (game.player.spe >= 100) {
				boost += 40;
				scal -= 1;
			}
			if (game.player.spe >= 50) {
				boost += 30;
				scal -= 1;
			}
			boost += Math.round(game.player.cor / scal);
			return (27 + boost);
		}
		
		override public function canEquip(doOutput:Boolean):Boolean {
			if (game.player.level >= 54) return super.canEquip(doOutput);
			if(doOutput) outputText("You try and wield the legendary bow but to your disapointment the item simply refuse to stay in your hands. It would seem you yet lack the power and right to wield this item.");
			return false;
		}
		
	}

}