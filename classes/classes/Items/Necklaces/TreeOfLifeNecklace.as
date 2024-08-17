/**
 * ...
 * @author Ormael
 */
package classes.Items.Necklaces 
{
	import classes.GlobalFlags.kFLAGS;
	import classes.Items.Necklace;
	import classes.Scenes.SceneLib;
	
	public class TreeOfLifeNecklace extends Necklace
	{
		
		public function TreeOfLifeNecklace() 
		{
			super("TreeLNe", "TreeLifeNecklace", "Tree of Life Necklace", "a Tree of Life Necklace", 0, 0, 500, "A necklace made of branches that symbolize tree of life with strong aura of life surrounding it. Rumored to be blessed by the god of life have amazing effect for any living being that would wear it. \n\nType: Jewelry (Necklace) \nBase value: 500 \nSpecial: +5%/-5% HP regeneration (others / undead)","Necklace");
		}
		
		override public function afterEquip(doOutput:Boolean):void {
			SceneLib.setItemsChecks.equipTreeOfLifeItemsSet();
			super.afterEquip(doOutput);
		}
		
		override public function afterUnequip(doOutput:Boolean):void {
			SceneLib.setItemsChecks.unequipTreeOfLifeItemsSet();
			super.afterUnequip(doOutput);
		}
	}
}