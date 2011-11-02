package birth.trainer {
	import flash.events.Event;
	import flash.display.Sprite;
	
    public class ActionDeck {

		private var actions:Array;
		public var name:String = new String();
		private var topCardId:int;

		public function getActions():Array {
			return actions;
		}

		// next action (deal one card)
		public function nextAction():ActionCard {
			var n:ActionCard;

			if (actions.length == 0) {
				// Fill up the actions array
				actions = AssetManager.loadXML();
				
				shuffle();
			}
			
			n = actions.pop();
			trace (this.name + ": Action popped: " + n.actionName);
			
			return n;
		}
		
		// shuffle
		public function shuffle():void {
			for (var i:uint = 0; i < actions.length; i++) {
				actions[i].reseed();
			}

			actions = actions.sortOn("seed", Array.DESCENDING | Array.NUMERIC);
			
			trace(this.name + ": Sorting " + actions.length + " action cards in the deck.");
			for (i = 0; i < actions.length; i++) {
				trace("  " + i + ": " + actions[i].actionName + " (" + actions[i].id + ")");
			}
			topCardId = actions[0].id;
		}
		
		public function getCardById(id:int):ActionCard {
			var a:Array = new Array();
			a = actions.sortOn("id", Array.DESCENDING | Array.NUMERIC);
			return a[id];
		}
	 

		// constructor
		public function ActionDeck() {

			// Fill up the actions array
			actions = AssetManager.loadXML();

			name = "ActionDeck";
			
			// Shuffle
			shuffle();
		}
	}
}