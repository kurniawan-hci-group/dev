package birth.trainer {
    import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.filters.DropShadowFilter;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.kirupa.Scrollbar.*;
	import com.dVyper.utils.Alert;
	import birth.ui.*;
	
    public class LadyContainer extends Sprite {

		private var lady:Array = new Array();
		private var _selectedLady:Lady = null;
		private var _hoveredLady:Lady = null;
		private var nladies:int;

		private var alwaysSelected:Boolean;
		
		private var _stage:Stage;
		
		// constructor
		public function LadyContainer(stage:Stage, number:int, userLadySelection:int) {
			var i:int, row:int, col:int;
			var b:Boolean; // To make sure at least one lady came in
			
			_stage = stage;
			
			alwaysSelected = (number == 1)? true : false
			nladies = number;

			if (alwaysSelected == true) {
				lady[0] = new Lady(_stage, 0, chooseFirstName(userLadySelection - 1));
			}
			
			else {
				// Create all the ladies 
				for (i = 0; i < number; i++) {
					lady[i] = new Lady(_stage, i, chooseFirstName(i));
				}
				trace (i + " ladies created.");
			}
			
			// If just one lady, select her always.
			if (alwaysSelected) {
				_selectedLady = lady[0];
			}
			else {
				// No need to explicitly select if one lady
				addEventListener(MouseEvent.MOUSE_DOWN, selectLady);
			}
			
			// Place the ladies on the stage
			
			i = 0;
			b = false;
			for each (var v:Lady in lady) {
				if (alwaysSelected) {
					v.y = ((_stage.height) >> 1) - 50; // which row
					v.x = ((_stage.width) >> 1) - 100; // which col
				}
				else {
					row = i / Constant.MAX_LADIES_PER_ROW;
					col = i % Constant.MAX_LADIES_PER_ROW;
					v.y = row * 170 + 100; // which row
					v.x = col * 150 + 100; // which col
				}
				if (v.getLocation() == Constant.LOCATION_ROOM) {
					addChild(v);
					b = true; // At least one lady is added
				}
				v.addEventListener(MouseEvent.ROLL_OVER, hoverLady);
				v.addEventListener(MouseEvent.ROLL_OUT, unhoverLady);
				i++;
			}
			// No ladies on the screen -- add one
			if (b == false) {
				trace ("No ladies added to stage. Forcing one lady to come in.");
				lady[0].setLocation(Constant.LOCATION_ROOM);
				addChild(lady[0]);
			}
        }
		
		public function showHitpointBar():void {
			_selectedLady.showHitpointBar();
		}
		
		public function startDilationTimer():void {
		}
		
		private function chooseFirstName(n:int):String {
			var r:Number = (Math.random() > 0.5)? 0: 1;
			switch (n) {
				case 0: return (r == 0)? "Amy"       : "Amanda";//"Emily" : "Ruth";
				case 1: return (r == 0)? "Beth"      : "Becca"; //"Lisa" : "Sarah";
				case 2: return (r == 0)? "Caitlin"   : "Christine";// "Amy": "Melanie";
				case 3: return (r == 0)? "Deborah"   : "Diane";//"Susan": "Rebecca";
				case 4: return (r == 0)? "Emily"     : "Elizabeth";//"Caitlin" : "Faith";
				case 5: return (r == 0)? "Faith"     : "Francis"; //"Helen" : "Lisa";
				case 6: return (r == 0)? "Genevieve" : "Grace";// "Jennifer" : "Michelle";
				
				default: return "Nikki" + n;
			}
		}
		public function howManyLadies():int {
			return nladies;
		}
		public function getLady(i:int):Lady {
			return lady[i];
		}
		
		// Unselect each lady
		public function unselectAll():void {
			if (alwaysSelected) return;
			for each (var key:Lady in lady) {
				key.unselect();
				_selectedLady = null;
			}
		}
		
		// Event handler for hovered lady:
		// Set _hoveredLady to the one that's being rolled over
		public function hoverLady(event:MouseEvent):void {
			if (event.target is Lady) {
				_hoveredLady = event.target as Lady;				
			}
		}
		
		// Event handler for hovered lady:
		// Unset the _hoveredLady
		public function unhoverLady(event:MouseEvent):void {
			_hoveredLady = null;
		}
		
		// Event handler for mouse down:
		// Select the appropriate lady
		public function selectLady(event:MouseEvent):void {
			// Make sure it's a lady
			if (event.target.parent is Lady) {
				_selectedLady = event.target.parent as Lady;
				
				// If she's had her baby, remove the clicked listener
				// And unselect everything
				if ((_selectedLady.getStatus() == Constant.LADYSTATUS_ALIVE_HADBABY) ||
					 _selectedLady.getStatus() == Constant.LADYSTATUS_ALIVE_CORDCUT){
					_selectedLady.removeEventListener(MouseEvent.MOUSE_DOWN, selectLady);
					unselectAll();
					return;
				}
				
				// Selection handler
				if (_selectedLady.isSelected() == true) {
					_selectedLady.unselect();
					_selectedLady = null;
				}
				else {
					_selectedLady.select();
					for each (var v:Lady in lady) {
						if (v != _selectedLady) {
							v.unselect();
						}
					}
				}
			}
		}
		
		// Getter: _selectedLady
		public function get selectedLady():Lady {
			return _selectedLady;
		}
		
		// Getter: _hoveredLady
		public function get hoveredLady():Lady {
			return _hoveredLady;
		}
		
		// Apply the input action card to the selected lady
		public function applyCardToSelected(card:ActionCard):Boolean {
			if (_selectedLady == null) {
				trace ("Unable to apply card to null lady.");
				return false;
			}

			if (card.id == Constant.CARD_GOHOME_ID){
			// Handle going home
				if (_selectedLady.getDilation() <= Constant.DILATION_ACTIVE){
					_selectedLady.setLocation(Constant.LOCATION_GOINGHOME);
				}
				else {
					return false;
				}
			}
			
			// Add the buff
			return _selectedLady.addEffectCard(card);
		}

		/// Evaluate each lady
		public function tick():Boolean {
			var hasActiveLady:Boolean = false;
			
			for each (var v:Lady in lady) {

				// active lady handler
				if (v.getStatus() == Constant.LADYSTATUS_ALIVE_INLABOR) {
				
					if (v.getLocation() == Constant.LOCATION_HOME) {
						if (v.getDilation() >= Constant.DILATION_ACTIVE) {
							trace(v.getFirstName() + " is at home during active labor (dilation " + v.getDilation() + ").");
							// consider bringing her back
						}
					}
					
					// She was on her way, but now she is here
					if (v.getLocation() == Constant.LOCATION_COMINGIN) {
						v.setLocation(Constant.LOCATION_ROOM);
					}
				
					// Do we need to bring her in?
					if (v.getLocation() != Constant.LOCATION_ROOM){
						if (v.getDilation() >= Math.random()*Constant.DILATION_ACTIVE+1) {
							v.setLocation(Constant.LOCATION_COMINGIN);
							addChild(v);
							trace("*** " + v.getFirstName() + ": \"I'm here!\"");
						}
					}
					
					// Tick the lady
					v.tick();
					
					// There was at least one lady active
					hasActiveLady = true;
				}
				
				// inactive lady handler
				else {
					// Each lady that was skipped (inactive or had baby)
				}				
			} // each v in ladies


			// no active ladies - game over
			if (hasActiveLady == false) {
				
				trace("All ladies done");
				
				// Calculate the score: total hit points
				var total_hp:int = 0;
				for each (v in lady) {
					total_hp += v.score;
				}
				
				// Give some output
				trace("*** =====================")
				trace("*** G A M E   O V E R");
				trace("*** =====================")
				trace("*** Your score is " + total_hp);
				trace("*** Thanks for playing The Prepared Partner");
				ScrollContent.appendContent("*** =====================")
				ScrollContent.appendContent("*** G A M E   O V E R");
				ScrollContent.appendContent("*** =====================")
				ScrollContent.appendContent("*** Your score is " + total_hp);
				ScrollContent.appendContent("*** Thanks for playing The Prepared Partner");
			}
			
			return hasActiveLady;
		}
	}
}