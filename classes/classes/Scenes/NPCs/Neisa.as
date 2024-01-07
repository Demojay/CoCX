/**
 * ...
 * @author Ormael
 */
package classes.Scenes.NPCs
{
import classes.*;
import classes.BodyParts.Butt;
import classes.BodyParts.Hips;
import classes.GlobalFlags.kFLAGS;
import classes.IMutations.CatLikeNimblenessMutation;
import classes.IMutations.DraconicLungMutation;
import classes.IMutations.GorgonEyesMutation;
import classes.IMutations.IMutationsLib;
import classes.IMutations.LactaBovinaOvariesMutation;
import classes.IMutations.LizanMarrowMutation;
import classes.IMutations.OniMusculatureMutation;
import classes.IMutations.OrcAdrenalGlandsMutation;
import classes.IMutations.PigBoarFatMutation;
import classes.Scenes.SceneLib;
import classes.Followers.Follower;
import classes.Followers.FollowerManager;

	public class Neisa extends Follower
	{
		override public function defeated(hpVictory:Boolean):void
		{
			SceneLib.neisaFollower.neisaSparWon();
		}

		override public function won(hpVictory:Boolean,pcCameWorms:Boolean):void
		{
			SceneLib.neisaFollower.neisaSparLost();
		}
		
		public function Neisa()
		{
			timerStatusEffect = StatusEffects.CampSparingNpcsTimers4;
        	timerStatusPosition = 4;
			levelCap = 11;
			followerLevel = followerManager.followerLevels[FollowerManager.FOLLOWER_NEISA]["level"];
			
			//  Her skin is dusky, nearly chocolate except for a few white spots spattered over her body.
			if (followerLevel == 1) {
				initStrTouSpeInte(50, 80, 50, 44);
				initWisLibSensCor(44, 52, 25, 50);
				this.weaponAttack = 12;
				this.armorDef = 0;
				this.armorMDef = 0;
				this.bonusHP = 200;
				this.bonusLust = 80;
				this.level = 3;
			}
			if (followerLevel >= 2 && followerLevel < 9) {
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
			if (followerLevel == 9) {
				initStrTouSpeInte(170, 256, 130, 108);
				initWisLibSensCor(108, 100, 65, 50);
				this.weaponAttack = 36;
				this.armorDef = 64;
				this.armorMDef = 16;
				this.bonusHP = 1800;
				this.bonusLust = 216;
				this.level = 51;
			}
			if (followerLevel == 10) {
				initStrTouSpeInte(185, 278, 140, 116);
				initWisLibSensCor(116, 106, 70, 50);
				this.weaponAttack = 39;
				this.armorDef = 72;
				this.armorMDef = 18;
				this.bonusHP = 2000;
				this.bonusLust = 233;
				this.level = 57;
			}//level up giving 2x all growns and so follow next level ups's as long each npc break lvl 100 (also makes npc use new better gear) (also makes npc use new better gear)
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
			this.createPerk(PerkLib.JobGuardian, 0, 0, 0, 0);
			this.createPerk(PerkLib.ShieldWielder, 0, 0, 0, 0);
			this.createPerk(PerkLib.Ferocity, 0, 0, 0, 0);
			this.createPerk(PerkLib.LizanRegeneration, 0, 0, 0, 0);
			if (followerLevel >= 2) {
				this.createPerk(PerkLib.Diehard, 0, 0, 0, 0);
				this.createPerk(PerkLib.TankI, 0, 0, 0, 0);
			}
			if (followerLevel >= 3) {
				this.createPerk(PerkLib.JobKnight, 0, 0, 0, 0);
				this.createPerk(PerkLib.Regeneration, 0, 0, 0, 0);
				this.createPerk(PerkLib.Resolute, 0, 0, 0, 0);
			}
			if (followerLevel >= 4) {
				this.createPerk(PerkLib.ImprovedDiehard, 0, 0, 0, 0);
				this.createPerk(PerkLib.RefinedBodyI, 0, 0, 0, 0);
				this.createPerk(PerkLib.ImmovableObject, 0, 0, 0, 0);
			}
			if (followerLevel >= 5) {
				this.createPerk(PerkLib.JobDefender, 0, 0, 0, 0);
				this.createPerk(PerkLib.Juggernaut, 0, 0, 0, 0);
				this.createPerk(PerkLib.GoliathI, 0, 0, 0, 0);
			}
			if (followerLevel >= 6) {
				IMutationsLib.CatLikeNimblenessIM.acquireMutation(this, "none", 2);
				IMutationsLib.GorgonEyesIM.acquireMutation(this, "none", 2);
				this.createPerk(PerkLib.GreaterDiehard, 0, 0, 0, 0);
			}
			if (followerLevel >= 7) {
				IMutationsLib.DraconicLungIM.acquireMutation(this, "none");
				IMutationsLib.LizanMarrowIM.acquireMutation(this, "none");
				this.createPerk(PerkLib.CheetahI, 0, 0, 0, 0);
			}
			if (followerLevel >= 8) {
				IMutationsLib.OniMusculatureIM.acquireMutation(this, "none");
				IMutationsLib.OrcAdrenalGlandsIM.acquireMutation(this, "none");
				this.createPerk(PerkLib.EpicDiehard, 0, 0, 0, 0);
			}
			if (followerLevel >= 9) {
				IMutationsLib.LactaBovinaOvariesIM.acquireMutation(this, "none", 2);
				IMutationsLib.PigBoarFatIM.acquireMutation(this, "none");
			}
			if (followerLevel >= 10) {
				this.createPerk(PerkLib.EpicToughness, 0, 0, 0, 0);
				this.createPerk(PerkLib.EpicStrength, 0, 0, 0, 0);
			}
			if (followerLevel >= 11) {
				IMutationsLib.DraconicLungIM.acquireMutation(this, "none");
				IMutationsLib.OniMusculatureIM.acquireMutation(this, "none");
				IMutationsLib.OrcAdrenalGlandsIM.acquireMutation(this, "none");
				IMutationsLib.PigBoarFatIM.acquireMutation(this, "none");
			}
			/*
			updateDynamicPerkBuffs(IMutationsLib.DraconicLungIM, DraconicLungMutation, this);
			updateDynamicPerkBuffs(IMutationsLib.OniMusculatureIM, OniMusculatureMutation, this);
			updateDynamicPerkBuffs(IMutationsLib.PigBoarFatIM, PigBoarFatMutation, this);
			updateDynamicPerkBuffs(IMutationsLib.OrcAdrenalGlandsIM, OrcAdrenalGlandsMutation, this);
			updateDynamicPerkBuffs(IMutationsLib.LizanMarrowIM, LizanMarrowMutation, this);
			updateDynamicPerkBuffs(IMutationsLib.CatLikeNimblenessIM, CatLikeNimblenessMutation, this);
			updateDynamicPerkBuffs(IMutationsLib.GorgonEyesIM, GorgonEyesMutation, this);
			updateDynamicPerkBuffs(IMutationsLib.DraconicLungIM, DraconicLungMutation, this);
			updateDynamicPerkBuffs(IMutationsLib.LactaBovinaOvariesIM, LactaBovinaOvariesMutation, this);
			*/
			checkMonster();//make her lvl 3 starting with internal mutation for: cat, dragon, gorgon, lacta bovina, lizard, oni, orc, pig/boar - plus job: guardian perk
		}

		/////////////////////////////////////////////////////////////////////////////////////////////////
		//Follower Functions
		/////////////////////////////////////////////////////////////////////////////////////////////////

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
