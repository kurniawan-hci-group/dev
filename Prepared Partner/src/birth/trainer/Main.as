package birth.trainer
{
	import flash.display.Sprite;
	import flash.events.Event;
    import flash.events.MouseEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.Timer;
	import birth.trainer.Lady;
	import flash.text.*;
	import flash.display.*;
	import com.onebyonedesign.ui.OBO_ToolTip;
	import com.kirupa.Scrollbar.*;
	import birth.ui.*;
	import com.dVyper.utils.*;
	
	/**
	 * ...
	 * @author fire
	 */
	public class Main extends Sprite 
	{
		
		private var bar:ActionBar;
		private var ladies:LadyContainer;
		
		private var splash_wrapper:Sprite = new Sprite();
		private var splash_bitmap:Bitmap;
		private var playicon_wrapper:Sprite = new Sprite();
		private var playicon_bitmap:Bitmap;
		private var backicon_wrapper:Sprite = new Sprite();
		private var backicon_bitmap:Bitmap;
		
		private var _stage:Stage;
		
		private var waves:Bitmap;
		
		// Tutorial?
		private var _tutorial:Boolean;
		// Tutorial: what to call her
		private var _tutorial_firstname:String;

		// Global system time
		private var time:Timer;
		
		// For the tooltip
		private var _toolTip:OBO_ToolTip;

		// Status window
		private var _status_window:TextField = new TextField();
		
		// Background
		private var background:Shape = new Shape();
		
		// First action generates a tutorial alert
		private var _makeFirstActionAlert:Boolean = false;

		private var majorTick:Timer;
		private var majorTickDelay:int = Constant.MAJORTICK;

		public function Main(stage:Stage, userLadySelection:int = 0):void {
			_stage = stage;
			init(null, userLadySelection);
			_tutorial = false;
			
			AssetManager.init();
		}
		
		private function init(e:Event = null, userLadySelection:int = 0):void {
			// entry point
			_toolTip = OBO_ToolTip.createToolTip(_stage);

			// Add the action bar
			bar = new ActionBar(Constant.MAX_ACTION_CARDS);
			bar.x = 50;
			bar.y = 450;
			_stage.addChild(bar);

			// Add the ladies
			ladies = new LadyContainer(_stage, Constant.MAX_LADIES, userLadySelection);
			ladies.x = 0; ladies.y = 0;
			_stage.addChild(ladies);
			
			// Add event listeners
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, applyActionToLady);
			ladies.addEventListener(MouseEvent.ROLL_OVER, showArrows);
			ladies.addEventListener(MouseEvent.ROLL_OUT, hideArrows);

			// Status bar - for lady
			new StatusBar(_stage, (_stage.width>>1) - ((bar.width >> 1) + 80), (bar.y - 25));
			StatusBar.showStatus("Welcome to The Prepared Partner!");
			// Status window
			createStatusWindow();

			// Status area - for actions
			new StatusArea(_stage, 20, 425);
			
			// Stats tracker
			new StatsTracker(_stage);
			StatsTracker.registerInviteCode(_stage.loaderInfo.parameters.inviteCode);

			// Alert
			Alert.init(_stage);
			
			// Skip tutorial
			if (userLadySelection == 0) {
				startTheGame();
			}
			else {
				// Tutorial 1
				var tut:Timer = new Timer(750, 1); // .750 seconds
				tut.addEventListener(TimerEvent.TIMER_COMPLETE, alert1);
				tut.start();
				_makeFirstActionAlert = true;
			}
		}
		private function alert1(e:TimerEvent):void {
			_tutorial_firstname = ladies.selectedLady.getFirstName();
			Alert.show(
				"Welcome to The Prepared Partner!\n\nWould you like to see the tutorial?" ,
				{callback:alert2, buttons:["Yes","No"]});
		}
		private function alert2(response:String):void {
			if (response == "No") {
				startTheGame();
			}
			else {
			Alert.show(
				_tutorial_firstname + " thinks she's in labor.  " +
				"Help her cope with her contractions and deliver a baby safely!",
				{callback:alert3 } );
			}
		}
		
		private function alert3(response:String):void {
			Alert.show(
				"These are action cards.  " + 
				"Use the actions to help " + _tutorial_firstname + " cope with her labor.  " +
				"The trash discards all actions and gives you new ones.", 
				{callback:alert4, position: new Point(123, 356)} );
		}
		private function alert4(response:String):void {
			Alert.show(
				"The arrows beneath each action tell you what the action does to " + _tutorial_firstname + ".",
				{callback:alert5, position: new Point(400, 356) } );
			bar.showArrows(ladies.selectedLady);
		}

		private function alert5(response:String):void {
			Alert.show(
				_tutorial_firstname + "'s health tells you how well she is coping with her labor. " +
				"If her health, or any of her stats, goes to 0, the doctor will come take " + _tutorial_firstname + " for a c-section.",
				{callback:alert6, position: new Point(ladies.selectedLady.x - 150, ladies.selectedLady.y - 60)} );
		}
		private function alert6(response:String):void {
			ladies.showHitpointBar();
			Alert.show(
				"The bars over " + _tutorial_firstname + " show her\n" +
				"energy, physical support, cognitive support, and\n" +
				"strength of her contractions.",
				{callback:alert7, position: new Point(ladies.selectedLady.x, ladies.selectedLady.y)} );
		}
		private function alert7(response:String):void {
			Alert.show(
				"The number in " + _tutorial_firstname + "'s belly is " +
				"her cervical dilation.",
				{callback:alerts_done, position: new Point(ladies.selectedLady.x + 60, ladies.selectedLady.y + 60)} );
		}
		private function alerts_done(response:String):void {
			Alert.show("Good luck!", {callback:startTheGame});
		}
		
		private function startTheGame(response:String = null):void {
			// Start the timer
			majorTick = new Timer(majorTickDelay);
			majorTick.addEventListener(TimerEvent.TIMER, tick);
			majorTick.start();
			ladies.showHitpointBar();
			bar.showArrows(ladies.selectedLady);
			_makeFirstActionAlert = false;
			
		}
		
		private function restart(response:String = null):void {
			Alert.show("Restarting");
		}

		private function tick(e:TimerEvent):void {
			for each (var l:Lady in ladies) {
				if (Constant.getStageOfLabor(l.getDilation()) != Constant.INDEX_EARLY) {
					bar.updateArrows(Constant.getStageOfLabor(l.getDilation()));
				}
			}
			if (ladies.tick() == false) {
				trace("Main says: GAME OVER");
				cleanUp();
			}
		}
		
		private function cleanUp():void {
			// Stop the timer
			majorTick.removeEventListener(TimerEvent.TIMER, tick);
			
			_stage.removeChild(bar);
			
			// Show some stats
			Alert.show(StatsTracker.getInfo(), {position:new Point(50, 200), background:"nonenotmodal"});

			// Send result stats to file
			var request:URLRequest= new URLRequest ("http://users.soe.ucsc.edu/~fire/pp/pp-end.php");
			request.method = URLRequestMethod.POST;

			var variables:URLVariables = StatsTracker.getStatsVariables();
			
			request.data = variables;
			
            var urlLoader:URLLoader = new URLLoader (request);
            urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompletehandler);
            urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
            urlLoader.load(request);
        }
        
        public function urlLoaderCompletehandler(event:Event) : void
        {
            var variables:URLVariables = new URLVariables( event.target.data );
             
            if (variables.error != null) trace("NO VARIABLES");
            else trace (event.target.data);
        
			Alert.show("Play again?", {callback:replay,position:new Point(10, 10), background:"nonenotmodal"});
        }
		public function replay(response:String):void {
			navigateToURL(new URLRequest("http://users.soe.ucsc.edu/~fire/pp/pp.php?inviteCode="+StatsTracker.inviteCode), "_self" );
		}
		
		private function createStatusWindow():void {
			var number_lines:int = 1000;
			var tf:TextFormat = new TextFormat("Arial", 9, 0x0);
			_status_window.defaultTextFormat = tf;
			_status_window.border = true;
			_status_window.borderColor = 0x0;
			_status_window.background = true;
			_status_window.backgroundColor = 0xffffff;
			_status_window.width = _stage.width >> 2;
			_status_window.x = _stage.width - _status_window.width - 10;
			_status_window.y = 0;
			_status_window.wordWrap = true;
			_status_window.text = "Welcome to The Prepared Partner!\n\n";
			_status_window.height = _status_window.numLines * number_lines; // Arbitrary
			
            var sc:ScrollContent = new ScrollContent(_stage, _status_window, 
				new Rectangle(0, 0, number_lines, _stage.height));
		}

		private function unselectAll():void {
			ladies.unselectAll();
			bar.unselectAll();
		}
		
		// Show hint arrows on hover
		private function showArrows(event:MouseEvent = null):void {
			bar.showArrows(ladies.hoveredLady);
		}
		// Hide hint arrows if a lady is not selected
		private function hideArrows(event:MouseEvent = null):void {
			if (ladies.selectedLady == null) {
				bar.hideArrows();
			}
		}
		private function playGenericSuccessTimer(e:Event):void {
			var timer:Timer = new Timer(750, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, playGenericSuccessSound)
			timer.start();
		}
		private function playGenericFailureTimer(e:Event):void {
			var timer:Timer = new Timer(750, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, playGenericFailureSound)
			timer.start();
		}
		private function playGenericSuccessSound(e:Event):void {
			var channel:SoundChannel = AssetManager.getResultSound().play();			
		}
		private function playGenericFailureSound(e:Event):void {
			var channel:SoundChannel = AssetManager.getResultSound().play();
		}

		private function failure(lady:Lady, card:ActionCard, words:String = ""):void {
			// Wrong guess
			lady.changeScore( -10); // take away score

			// Log the error
			StatsTracker.pushActionFailure(card, lady.getDilation(), words);
			
			// Play card name, then generic failure sound
			var channel:SoundChannel = card.audioCardName.play();
			channel.addEventListener(Event.SOUND_COMPLETE, card.playAudioFailure);
			channel.addEventListener(Event.SOUND_COMPLETE, lady.wrongGuess);

			// No effect string
			var status:String = new String(card.actionName + " had no effect on " + lady.getFirstName());
			trace(status);
			ScrollContent.appendContent(status);
			StatusBar.showStatus(status);
			
		}
		private function success(lady:Lady, card:ActionCard, words:String = ""):void {
			if (_makeFirstActionAlert) {
				Alert.show("If you want to cancel the effect, just click on it, or start a new effect.");
				_makeFirstActionAlert = false;
			}
			lady.changeScore(2); // increase score
			
			// Log the success
			StatsTracker.pushActionSuccess(card, lady.getDilation());
			
			// Play the name of the card
			var channel:SoundChannel = card.audioCardName.play();
			channel.addEventListener(Event.SOUND_COMPLETE, card.playAudioSuccess);


			trace ("Applying action [" + card.actionName + "] to " + lady.getFirstName());
			ScrollContent.appendContent(lady.getFirstName() + ": " + card.getInfo() + "----");
			StatusBar.showStatus(lady.getFirstName() + " (" + Constant.getDilationString(lady.getDilation()) + "): " + card.actionName);
		}
        private function applyActionToLady(event:MouseEvent):void {
			var a:ActionCard;
			var s:ActionSlot;
			var l:Lady;

			// Show hint arrows if a lady is selected
			if (event.target.parent is Lady) {
				trace("Showing arrows for " + ladies.selectedLady);
				if (ladies.selectedLady != null) {
					bar.showArrows(ladies.selectedLady);
				}
				else {
					bar.hideArrows();
				}
			}

			if (event.target.parent is Lady || 
				event.target.parent is ActionSlot ||
				event.target.parent is ActionBar) {
				a = bar.getSelectedAction();
				s = bar.getSelectedSlot();
				l = ladies.selectedLady;

				if (a != null && l != null) {
					
					// The slot is on cooldown
					if (s.isActive() == false) {
						return;
					}
					
					// Success rate failure
					var cardChance:Number = Math.random();
					if (a.success < cardChance) {
						l.addEffectCard(a);
						trace("Random failure! Success: " + a.success + " Chance: " + cardChance);
						failure(l, a, "Random");
					}
					
					// Unable to apply card!
					else if (ladies.applyCardToSelected(a) == false) {
						trace("Lady refusal!");
						failure(l, a, "Refusal");
					}
					
					// all is well
					else {
						success(l, a);
					}
					
					if (s.isLockedSlot() != true) {
						bar.dealSlot(Constant.getStageOfLabor(l.getDilation()));
					}

					s.globalCooldown(Constant.GLOBAL_COOLDOWN);

					unselectAll();					
				}
			}
        }
	}
}