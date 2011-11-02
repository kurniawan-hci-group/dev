package birth.trainer {
	import com.dVyper.utils.Alert;
    import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.*;
	import flash.filters.DropShadowFilter;
	import flash.ui.MouseCursor;
	import flash.utils.Timer;
	import flash.ui.Mouse;
	import flash.text.*;
	import com.onebyonedesign.ui.OBO_ToolTip;
	import com.bluemagica.*;
	import com.kirupa.Scrollbar.*;
	import birth.ui.*;
	
    public class Lady extends Sprite {
		// Mechanics
		private var  _status:uint;
		private var  _lightsDimmed:Boolean;
		private var  _asleep:Boolean;
		private var  _atHome:Boolean;
		private var  _epidural:Boolean;
		private var  _drugs:Boolean;
		private var  _waters:Boolean;
		
		private var  _location:int;

		private var dilation:Number;
		private var hp:Number;			// hit points
		private var _score:Number;

		// These are directly affected by actions
		private var energy:Number;		// 0-100
		private var physSupport:Number;	// 0-100
		private var cogSupport:Number;	// 0-100
		private var strLabor:Number;
		private var lenLabor:Number;

//		private var effects:Array = new Array();
		private var theeffect:EffectCard;
		
		private var progressDilationNow:int;	// dilate now?
		private var progressHpNow:int;		// tick the hit points now?
		private var progressHpDirection:int; 
		
		private var stability:Number;	// 0-MAX_HP, E+P+C-S

		// Visual assets
		private var selected:Boolean;
		private var circle:Sprite = new Sprite();
		private var cervix:Sprite = new Sprite();
		private var thenameplate:Nameplate;
		private var baby:Bitmap;
		private var baby_nocord:Bitmap;
		private var doctor:Bitmap;
		private var arm1:Shape = new Shape();
		private var arm2:Shape = new Shape();
		private var leg1:Shape = new Shape();
		private var leg2:Shape = new Shape();
		private var selectedLady:Sprite = new Sprite();
		private var hoveredLady:Sprite = new Sprite();
		private var icon_home:Bitmap;
		private var waves:Bitmap;

		private var dil_text:Nameplate;
		
		private var _ds:DropShadowFilter;
		
		// Arms
		private var armMove:int;
		private var armDirection:Boolean;
		private var animationTimer:Timer;
		
		private var _ticksSansHpProgress:int;
		private var _ticksSansDilationProgress:int;
		
		private static const MAX_HP:Number = 250;

		private var hpcontainer:Sprite = new Sprite();
		private var ebar:healthbar;
		private var pbar:healthbar;
		private var cbar:healthbar;
		private var sbar:healthbar;
		private var hptxt:Nameplate;
		private var scoretxt:Nameplate;
		
		private var scissors:Bitmap;

		// To number the ladies
		private var number:int;
		
		// To name the ladies
		private var firstName:String;
		
		private var alwaysSelected:Boolean;

		// Colors and sizes
        private var size:uint           = 180;
        private var bgColor:uint        = 0xFFFF00;
		private var mouseoverColor:uint = 0xFFFF99;
		private var selectedColor:uint  = 0;
		private var hoveredColor:uint   = 0xFFFF99;
        private var cervixColor:uint    = 0xFF9933;
        private var gutter:uint         = 5;
		private var ladyx:uint          = 0;
		private var ladyy:uint          = 30;
		
		// For the effects
		private var actionCard:ActionCard;
		private var timer:Timer;
		private var scoreTimer:Timer;

		// Contractions
		private var contractionTimer:Timer;
		private var betweenContractionTimer:Timer;
		
		
		private var _stage:Stage;
		private var background:Shape = new Shape();
		

		
		private var _toolTip:OBO_ToolTip;
		
		// constructor
		public function Lady(stage:Stage, number:int, firstName:String, dilation:Number = 0) {
			this.number = number;
			this.firstName = firstName;
			this.dilation = dilation;

			_stage = stage;
			// Background
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(_stage.stageWidth,_stage.stageHeight,-Math.PI/4);
			background.graphics.beginGradientFill(GradientType.LINEAR,[0xF5F6CE,0xFBFBEF],[100,100],[0x00,0xFF],matrix);
			background.graphics.drawRect(0,0,_stage.stageWidth,_stage.stageHeight);
			background.graphics.endFill();
			_stage.addChildAt(background,0);
			
			// full health
			hp = MAX_HP;
			
			// No score
			_score = 0;

			// this one is alive, but no baby yet
			_status = Constant.LADYSTATUS_ALIVE_INLABOR;
			
			// Bag of waters intact
			_waters = true;
			
			// If sole lady, then always selected
			alwaysSelected = (Constant.MAX_LADIES == 1)? true : false;
			
			// Not selected
			selected = alwaysSelected;
			
			// Lights are dimmed
			_lightsDimmed = false;
			
			// Asleep?
			_asleep = false;
			
			// In the labor room?
			_location = (Math.random()*10 > 5)? 
				Constant.LOCATION_HOME :
				Constant.LOCATION_ROOM ;

			// Time until progress
			progressDilationNow = newProgressNumber();
			
			doDrawLady();
			
			// Make waves (but don't add them)
			waves = new AssetManager.background_waves() as Bitmap;

			// Max everything except labor strength
			setLadyMechanics(MAX_HP, 100, 100, Math.random()*20);
	
			_ticksSansDilationProgress = 0;
			_ticksSansHpProgress = 0;
			
//			contractionTimer = new Timer( 
		}
		
		private function newProgressNumber():Number {
			return Math.floor(Math.random()*Constant.TIME_UNTIL_PROGRESS + 1);
		}

		private function setGraphicalDilation(dil:Number):void {
			var innersize:int;
			if (dil != Constant.DILATION_ERR){
				innersize = ((dil / (Constant.DILATION_COMPLETE + 1)) * size) >> 1; // gives fraction of circle to fill
			}
			else {
				innersize = 0;
			}
			cervix.graphics.clear();
			cervix.graphics.beginFill(cervixColor);
			cervix.graphics.drawCircle(ladyx, ladyy, innersize);
			cervix.graphics.endFill();
			
			if (Math.floor(dil) >= Constant.DILATION_COMPLETE) {
				dil_text.updateText("Pushing");
			}
			else {
				dil_text.updateText(Math.floor(dil).toString());
			}
		}

		private function dilate_smallstep():void {
			setDilation(dilation + Constant.DILATION_SMALLSTEP);
			setGraphicalDilation(dilation);
			
			_ticksSansDilationProgress = 0;
		}
		private function setDilation(x:Number):void {
			// check for valid dilation range
			if (x < Constant.MIN_DILATION) {
				x = Constant.MIN_DILATION;
			}
			if (x > Constant.MAX_DILATION) {
				x = Constant.MAX_DILATION;
			}
			dilation = x;
		}
		public function getDilation():Number {
			return dilation; 
		}
		public function getStatus():uint {
			return _status;
		}
		public function isDimmed():Boolean {
			return _lightsDimmed;
		}
		public function getLocation():int {
			return _location;
		}
		public function setLocation(l:int):void {
			if (l <= 0) l = 0;
			_location = l;
			
			if (_location == Constant.LOCATION_GOINGHOME || _location == Constant.LOCATION_HOME) {
				removeChild(cervix);
				removeChild(circle);
				removeChild(arm1);
				removeChild(arm2);

				icon_home = new AssetManager.icon_home() as Bitmap;
				addChild(icon_home);
				icon_home.x = ladyx - size;
				icon_home.y = ladyy - size;
			}
			else if (_location == Constant.LOCATION_COMINGIN || _location == Constant.LOCATION_ROOM) {
				addChild(circle);
				addChild(cervix);
				addChild(arm1);
				addChild(arm2);
				if (icon_home != null && contains(icon_home)){
					removeChild(icon_home);
				}
			}
		}
		public function isEpidural():Boolean {
			return _epidural;
		}
		public function isConfinedToBed():Boolean {
			return (_epidural || _drugs);
		}
		
		private function doDrawLady():void {
			// Name these items
			name = "Lady" + number;
			circle.name = name + ".circle";
			cervix.name = name + ".cervix";			
			trace("Drawing " + firstName + " (" + name + "): ");
			trace(circle.name + " with cervix " + cervix.name);

			selectedLady.graphics.clear();
			hoveredLady.graphics.clear();
			
			circle.graphics.clear();			
			circle.graphics.beginFill(bgColor);
			circle.graphics.drawCircle(ladyx, ladyy, size >> 1);
			circle.graphics.endFill();

			thenameplate = new Nameplate(this, firstName, ladyx, ladyy + (size >> 1) + 3, true, false);

			var innersize:uint;
			if (dilation >= Constant.MIN_DILATION){
				innersize = (dilation/Constant.DILATION_COMPLETE) * (size >> 1); // gives portion of circle to fill
			}
			else {
				innersize = 0;
			}

			cervix.graphics.clear();
			cervix.graphics.beginFill(cervixColor);
			cervix.graphics.drawCircle(ladyx, ladyy, innersize);
			cervix.graphics.endFill();

			setDilation(dilation);

			dil_text = new Nameplate(cervix, Math.floor(dilation).toString(), ladyx, ladyy, false, true);

			arm1.graphics.clear();
			arm1.graphics.beginFill(bgColor);
			arm1.graphics.drawCircle(ladyx - (size >> 1) - gutter, ladyy, (size >> 3));
			arm1.graphics.endFill();
			arm2.graphics.clear();
			arm2.graphics.beginFill(bgColor);
			arm2.graphics.drawCircle(ladyx + (size >> 1) + gutter, ladyy, (size >> 3));
			arm2.graphics.endFill();
			armDirection = (Math.random()*10 > 5)? false:true;
			armMove = 5;

			// Add the children
			addChild(selectedLady);
			addChild(hoveredLady);

			addChild(arm1);
			addChild(arm2);
			addChild(circle);
			addChild(cervix);
			
			if (alwaysSelected) select();
			
			filters = [new DropShadowFilter(3, 45, 0x000000, .7, 2, 2, 1, 3)];

			// Hovering graphics
			circle.addEventListener(MouseEvent.ROLL_OVER, hover);
			circle.addEventListener(MouseEvent.ROLL_OUT,  unhover);
			
			// Get some tool tips going
			_toolTip = OBO_ToolTip.createToolTip(this);

			// Tool tip listeners
			circle.addEventListener(MouseEvent.ROLL_OVER, displayToolTip);
			circle.addEventListener(MouseEvent.ROLL_OUT, removeToolTip);
			cervix.addEventListener(MouseEvent.ROLL_OVER, displayToolTip);
			cervix.addEventListener(MouseEvent.ROLL_OUT, removeToolTip);

			animationTimer = new Timer(50);
			animationTimer.addEventListener(TimerEvent.TIMER, redraw);
			animationTimer.start();
			
			makeHitpointBar();
			
			// When the lady is taken off the stage
			addEventListener(Event.REMOVED, removed);
		}

		private function makeHitpointBar():void {
			var wid:int = 12;
			var hei:int = 80;
			var interspace:int = 65;
			
			// Add hit point bars to the display
			hptxt = new Nameplate(this, MAX_HP.toString(), 
				ladyx - circle.width - 30, ladyy - circle.height - 60, 
				false, true, false, true, 0x00ff00, 42);
			new Nameplate(this, firstName + "'s health", 
				ladyx - circle.width - 30, ladyy - circle.height - 10);

			ebar = new healthbar(0, 100, 100, wid, hei, 0, 1, 0xff00ff, 0xff00ff);
			new Nameplate(ebar, "Energy");
			hpcontainer.addChild(ebar);
			
			pbar = new healthbar(0, 100, 100, wid, hei, 0, 1, 0x0000ff, 0x0000ff);
			new Nameplate(pbar, "Physical\nsupport");
			hpcontainer.addChild(pbar);
			
			cbar = new healthbar(0, 100, 100, wid, hei, 0, 1, 0x00ffff, 0x00ffff);
			new Nameplate(cbar, "Cognitive\nsupport");
			hpcontainer.addChild(cbar);

			sbar = new healthbar(0, 100, 100, wid, hei, 0, 1, 0xffff00, 0xffff00);
			new Nameplate(sbar, "Strength of\ncontractions");
			hpcontainer.addChild(sbar);
			
			scoretxt = new Nameplate(this, "0", 
				ladyx + circle.width + 30, ladyy - circle.height - 60, 
				false, true, false, true, 0xbababa, 42);
			new Nameplate(this, "Your score", 
				ladyx + circle.width + 30, ladyy - circle.height - 10);

			// Center the bars over the lady
			ebar.x = 20;//hpbar.x + wid + interspace;
			ebar.y = 0;//hpbar.y + hei + 20;
			pbar.x = ebar.x + interspace;
			pbar.y = ebar.y;
			cbar.x = pbar.x + interspace;
			cbar.y = pbar.y;
			sbar.x = cbar.x + interspace;
			sbar.y = cbar.y;
			
			// Center the hit point bar over the lady
			hpcontainer.x = ladyx - (hpcontainer.width >> 1) - gutter;
			hpcontainer.y = - (size >> 1) - (hei) + gutter;
			
			if (firstName == "Nikki-1") {
				addChild(hpcontainer);
			}

		}
		public function showHitpointBar():void {
			addChild(hpcontainer);
        }
		
		private function setHp(n:Number):void {
			if (n > MAX_HP) n = MAX_HP;
			if (n < 0)   n = 0;
			hp = n;
			hptxt.updateText(Math.floor(hp).toString());// + "/" + MAX_HP.toString());
		}
		public function getFirstName():String {
			return firstName;
		}

		public function effectComplete(id:int = -1):void {
			if (theeffect != null) {
				theeffect = null;
			}
			
			trace("Effect complete for id " + id);
			switch (id) {
				case Constant.CARD_GOHOME_ID:
					setLocation(Constant.LOCATION_COMINGIN);
					break;
					
				case Constant.CARD_BIG_BATH_ID:
				case Constant.CARD_SHOWER_ID:
				case Constant.CARD_BATH_ID:
					if (_stage.contains(waves)) {
						_stage.removeChild(waves);
					}
					break;
			}
		}
		public function wrongGuess(e:Event):void {
			if (theeffect != null) {
				theeffect.cancelEffect("Incorrect guess");
			}
		}
		private function activateEffect(c:ActionCard, success:Boolean):void {
			if (_status != Constant.LADYSTATUS_ALIVE_INLABOR) {
				trace("Refusing to apply action to lady not in labor");
				return;
			}

			if (theeffect != null) {
				theeffect.cancelEffect("New effect: " + c.actionName);
			}

			theeffect = new EffectCard(this, c, success);

			// Effect will not be successful -- skip the fancy graphics
			if (success == false) {
				return;
			}

			trace("c.id: " + c.id);			
			switch(c.id) {
				// Make darker gradient
				case Constant.CARD_DIMLIGHTS_ID:
					var matrix:Matrix = new Matrix();
					matrix.createGradientBox(_stage.stageWidth,_stage.stageHeight,-Math.PI/4);
					background.graphics.clear();
					background.graphics.beginGradientFill(GradientType.LINEAR, [0xAF7817, 0xC68E17], [100, 100], [0x00, 0xFF], matrix);
					background.graphics.drawRect(0,0,_stage.stageWidth,_stage.stageHeight);
					background.graphics.endFill();
					_stage.addChildAt(background,1);
				break;
				
				
				// Make a splash!
				case Constant.CARD_BIG_BATH_ID:
				case Constant.CARD_SHOWER_ID:
				case Constant.CARD_BATH_ID:
					if (!(contains(waves))){
						_stage.addChildAt(waves, 2);
						waves.x = 0;
						waves.y = _stage.stageHeight - waves.height;
					}
				break;
			}

		}


		public function addEffectCard(c:ActionCard, success:Boolean = true):Boolean {
			var valid:Array = c.effectMatrix.getValidBits();
			var stage:int = Constant.getStageOfLabor(dilation);

			// Action will be successful
			if (success == true && valid[stage] == 1) {
				activateEffect(c, true);
				return true;
			}
			
			// Action will not be successful -- predetermined
			else {
				activateEffect(c, false);
				trace(c.actionName + " has no effect on " + firstName + " during " + Constant.getDilationString(dilation));
				StatusBar.showStatus(c.actionName + " has no effect on " + firstName + " during " + Constant.getDilationString(dilation));
				return false;
			}
		}

		public function redraw(e:TimerEvent):void {
			var pixels:uint = 1;
			//animation
			if (armDirection) {
				arm1.y = arm1.y + pixels;
				arm2.y = arm2.y + pixels;
				if (armMove-- == 0) {
					armMove = 5;
					armDirection = false;
				}					
			}
			else {
				arm1.y = arm1.y - pixels;
				arm2.y = arm2.y - pixels;
				if (armMove-- == 0) {
					armMove = 5;
					armDirection = true;
				}					
			}
		}
		public function changeScore(delta:Number):void {
			updateScore(_score + delta);
		}

		private function dilateOnStability():void {
			// Check that the lady is stable enough to progress
			if (stability > Constant.MIN_STAB_PROGRESS) {
				// Throw in some randomness
				if (Math.random() * 10 > 8) {
					dilate_smallstep();
					updateScore(_score + (strLabor & 3) + Constant.getStageOfLabor(dilation));
				}
			}
			// Check that the contractions' strength is
			// sufficient to open the cervix
			else {
				switch (Constant.getStageOfLabor(dilation)) {
					case Constant.INDEX_EARLY:
						if (strLabor >= (10 * (dilation - 1) + 5)) {
							dilate_smallstep();
							updateScore(_score + (strLabor & 3) + 1);
						}
						else {
							_ticksSansDilationProgress++;
						}
						break;
					case Constant.INDEX_ACTIVE:
						if (strLabor >= (10 * (dilation - 1) + 5)) {
							dilate_smallstep();
							updateScore(_score + (strLabor & 3) + 3);
						}
						else {
							_ticksSansDilationProgress++;
						}
						break;
					case Constant.INDEX_TRANSITION:
						if (strLabor >= (10 * (dilation - 1) + 5)) {
							dilate_smallstep();
							dilate_smallstep();
							dilate_smallstep();
							dilate_smallstep();
							dilate_smallstep();
							dilate_smallstep();
							updateScore(_score + (strLabor & 3) + 7);
						}
						else {
							_ticksSansDilationProgress++;
						}
						break;
					case Constant.INDEX_PUSHING:
						dilate_smallstep();
						updateScore(_score + 5);
						break;
					case Constant.INDEX_THIRD:
				}
			}
		}

		private function tickDownMechanics():void {
			// Tick down hit points
			var i:int = (Math.round(Math.random() * 5));
			switch (i) {
				case 1:
					setLadyMechanics(energy - 1, physSupport, cogSupport, strLabor);
					break;
				case 2:
					setLadyMechanics(energy, physSupport - 1, cogSupport, strLabor);
					break;
				case 3:
					setLadyMechanics(energy, physSupport, cogSupport - 1, strLabor);
					break;
				case 4:
					setLadyMechanics(energy, physSupport, cogSupport, strLabor + 1);
					break;
				default:
					_ticksSansHpProgress++;
					break;
			}
		}
		
		// Tick: make progress or count the time.
		public function tick():void {
			if (_status == Constant.LADYSTATUS_ALIVE_INLABOR) {

				var dBefore:Number = dilation;
				dilateOnStability();
				var dAfter:Number = dilation;

				// Log, if necessary, her stage of labor
				if (Constant.getStageOfLabor(dBefore) != Constant.getStageOfLabor(dAfter)) {
					StatsTracker.timeStageStart(Constant.getStageOfLabor(dAfter));
				}
				
				tickDownMechanics();
				
				// Congratulations! She's had a baby.
				// Conditions: dilation is complete and past pushing; she's still alive
				if ((dilation >= Constant.MAX_DILATION) && (_status == Constant.LADYSTATUS_ALIVE_INLABOR)) {
					giveBirth();
				}
				
				
				// Set her hp
				setHp(stability);

				// Die if hp reach 0, OR any stats
				if (hp <= 0) {
					die();
				}
				if (energy <= 0) {
					die();
				}
				if (physSupport <= 0) {
					die();
				}
				if (cogSupport <= 0) {
					die();
				}

				// Warn about ticks without progress
				
				if (_ticksSansDilationProgress > Constant.MAX_COOLDOWN) {
					var s:String = "*** WARNING: " + firstName + " needs to make some progress! The doctor is on his way!\n*** " + 
								firstName + " is stuck at " + Math.floor(dilation) + "cm." +
								"*** Hint: increase contraction strength, or increase hp !";
					Alert.show(s);
					ScrollContent.appendContent(s);
					trace("*** WARNING: No dilation progress for " + firstName + " in " + _ticksSansDilationProgress + " ticks!");
					trace("*** " + firstName + " is stuck at " + Math.floor(dilation) + "cm.");
					_ticksSansDilationProgress = 0;
					StatsTracker.addWarningAboutDilationProgress();
				}
				if (_ticksSansHpProgress > Constant.MAX_COOLDOWN) {
					trace("*** WARNING: No hit points progress for " + firstName + " in " + _ticksSansHpProgress + " ticks!");
					trace("*** " + firstName + " is stuck at " + hp + "hp.");
					_ticksSansHpProgress = 0;
					StatsTracker.addWarningAboutHpProgress();
				}

			} // alive
		}
		
		private function updateScore(value:int):void {
			_score = value;
			scoretxt.updateText(Math.floor(_score).toString());
			StatsTracker.score = _score;
		}
		
		public function modifyMechanics(m:EffectMatrix):void {
			var effects:Effect =  m.earlyLaborEffects;
			var stage:int;

			stage = Constant.getStageOfLabor(dilation);
			
			switch(stage) {
				case Constant.INDEX_EARLY:
					effects = m.earlyLaborEffects;
					break;
				case Constant.INDEX_ACTIVE:
					effects = m.activeLaborEffects;
					break;
				case Constant.INDEX_TRANSITION:
					effects = m.transitionEffects;
					trace(m.getPrintableEffectMatrix());
					break;
				case Constant.INDEX_PUSHING:
					effects = m.pushingEffects;
					break;
				case Constant.INDEX_THIRD:
					effects = m.thirdStageEffects;
					break;
				default:
					break;
			}

			// Visual effects
			if (effects.valid == 1) {
				// Good job, here's some points
				updateScore(score + 
					effects.energy +
					effects.physical +
					effects.cognitive +
					effects.strength);

				setLadyMechanics(energy + effects.energy, physSupport + effects.physical, cogSupport + effects.cognitive, strLabor + effects.strength);
				if (stage == Constant.INDEX_TRANSITION) trace("Making floating text.");
				if (effects.energy    != 0) new FloatingText(ebar, ((effects.energy    > 0)? "+" : "") + effects.energy.toString(),    (effects.energy    > 0? 0x00ff00: 0xbb0000));
				if (effects.physical  != 0) new FloatingText(pbar, ((effects.physical  > 0)? "+" : "") + effects.physical.toString(),  (effects.physical  > 0? 0x00ff00: 0xbb0000));
				if (effects.cognitive != 0) new FloatingText(cbar, ((effects.cognitive > 0)? "+" : "") + effects.cognitive.toString(), (effects.cognitive > 0? 0x00ff00: 0xbb0000));
				if (effects.strength  != 0) new FloatingText(sbar, ((effects.strength  > 0)? "+" : "") + effects.strength.toString(),  (effects.strength  > 0? 0x00ff00: 0xbb0000));
			}
		}
		
		public function get score():Number {
			return _score;
		}

		private function giveBirth():void {
			_status = Constant.LADYSTATUS_ALIVE_HADBABY;
			
			// Congrats!
			updateScore(_score + (100 * hp));
			StatsTracker.timeOfBirth();
			
			cervix.graphics.clear();
			circle.graphics.clear();
			hoveredLady.graphics.clear();
			selectedLady.graphics.clear();
			dil_text.updateText("");
			circle.graphics.beginFill(0x0000ff);
			circle.graphics.drawCircle(ladyx, ladyy, size >> 1);
			circle.graphics.endFill();
			
			// Background
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(_stage.stageWidth,_stage.stageHeight,-Math.PI/4);
			background.graphics.beginGradientFill(GradientType.LINEAR,[0xF5F6CE,0xFBFBEF],[100,100],[0x00,0xFF],matrix);
			background.graphics.drawRect(0,0,_stage.stageWidth,_stage.stageHeight);
			background.graphics.endFill();
			
			hoveredLady.graphics.clear();
			unselect();
			
			// Add a baby
			baby = new AssetManager.icon_baby();
			baby_nocord = new AssetManager.icon_baby_nocord();
			circle.addChild(baby);
			
			// Make some scissors, but don't add them yet
			scissors = new AssetManager.icon_scissors();
			
			deactivate();
			addEventListener(MouseEvent.MOUSE_DOWN, cutBabyHandler);
		}
		private function mouseMoveHandler(event:MouseEvent):void {
			scissors.x = event.localX;
			scissors.y = event.localY;
		}

		private function cutBabyHandler(me:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_DOWN, cutBabyHandler);
			circle.removeChild(baby);
			addChild(baby_nocord);
			
			_status = Constant.LADYSTATUS_ALIVE_CORDCUT;
			StatsTracker.timeOfCordCut();
			
			// Stop arm flapping
			animationTimer.removeEventListener(TimerEvent.TIMER, redraw);
		}
		
		public function die():void {
			trace("*** " + firstName + " has died.");
			ScrollContent.appendContent(firstName + " has been taken by the doctor.\n")

			_status = Constant.LADYSTATUS_DEAD;
			StatsTracker.timeofSection();
			
			circle.graphics.clear();
			cervix.graphics.clear();
			arm1.graphics.clear();
			arm2.graphics.clear();
			dil_text.updateText("");
			
			hoveredLady.graphics.clear();
			unselect();
			
			// Add a doctor
			doctor = new AssetManager.icon_doctor();
			circle.addChild(doctor);
			doctor.x = -(circle.width >> 1);
			doctor.y = -(circle.height >> 1);

			animationTimer.removeEventListener(TimerEvent.TIMER, redraw);
			StatusBar.showStatus(firstName + " has been taken for a C-section.");
			deactivate();
		}

		public function deactivate():void {
			if (theeffect != null) {
				if (theeffect.isActive()) {
					if (_status == Constant.LADYSTATUS_ALIVE_HADBABY) {
						theeffect.cancelEffect(firstName + " had her baby.");
					}
					else if (_status == Constant.LADYSTATUS_DEAD) {
						theeffect.cancelEffect(firstName + " died.");
					}
					else {
						theeffect.cancelEffect();
					}
				}
			}
		}
		
		
		private function setLadyMechanics(e:Number, p:Number, c:Number, s:Number):void {
			if (e < 0) 	  e = 0;
			if (e > 100)  e = 100;
			if (p < 0)    p = 0;
			if (p > 100)  p = 100;
			if (c < 0)    c = 0;
			if (c > 100)  c = 100;
			if (s < 0)    s = 0;
			if (s > 100)  s = 100;
			energy 			= e;
			physSupport 	= p;
			cogSupport 		= c;
			strLabor 		= s;
			
			stability = energy + physSupport + cogSupport - strLabor;
			
			ebar.update(energy);
			pbar.update(physSupport);
			cbar.update(cogSupport);
			sbar.update(strLabor);

			_ticksSansHpProgress = 0;
		}
		
		public function removed(event:Event):void {
		}
		
		private function hover(event:MouseEvent):void {
			hoveredLady.graphics.beginFill(hoveredColor, 0.3);
			hoveredLady.graphics.drawCircle(ladyx, ladyy, (size >> 1) + 3);
			hoveredLady.graphics.endFill();
		}
		private function unhover(event:MouseEvent):void {
			hoveredLady.graphics.clear();
		}
		public function isSelected():Boolean {
			return this.selected;
		}
		public function select():void {
			if (alwaysSelected) return;
			selectedLady.graphics.beginFill(selectedColor, 0.8);
			selectedLady.graphics.drawCircle(ladyx, ladyy, (size >> 1) + 3);
			selectedLady.graphics.endFill();
			setChildIndex(selectedLady, 0); // send to background

			selected = true;
		}
		public function unselect():void {
			if (alwaysSelected) return;
			selectedLady.graphics.clear();
			selected = false;
		}
		private function displayStatsToolTip(me:MouseEvent):void {
			_toolTip.addTip("Health: " + Math.floor(hp) + "/" + MAX_HP + "\n" +
							"Energy: " + Math.floor(energy) + "/100\n" +
							"Physical support: " + Math.floor(physSupport) + "/100\n" +
							"Cognitive support: " + Math.floor(cogSupport) + "/100\n" +
							"Strength of labor: " + Math.floor(strLabor) + "/100");
		}
		private function displayToolTip(me:MouseEvent):void {
			if (_status == Constant.LADYSTATUS_ALIVE_HADBABY) {
//				_toolTip.addTip("Congratulations! " + firstName + " had her baby!");
				StatusBar.showStatus("Congratulations! " + firstName + " had her baby!");
				Mouse.hide();
				addChild(scissors);
				addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			}
			else if (_status == Constant.LADYSTATUS_ALIVE_INLABOR) {
				if (dilation > Constant.DILATION_COMPLETE) {
					_toolTip.addTip(firstName + " is pushing!");
					StatusBar.showStatus(firstName + " is pushing!");
				}
				else if (_asleep) {
					_toolTip.addTip(firstName + ": Shh, I'm trying to sleep.");
				}
				
				if (hp > 200) {
					if ((Math.random() * 16) > 8) {
						_toolTip.addTip(firstName + ": I'm doing great!");
					}
					else {
						_toolTip.addTip(firstName + ": This is exciting!");
					}
				}
				else if (hp > 100) {
					if ((Math.random() * 16) > 8) {
						_toolTip.addTip(firstName + ": I'm doing OK.");
					}
					else {
						_toolTip.addTip(firstName + ": This is hard work.");
					}
				}
				else if (hp > 80) {
					_toolTip.addTip(firstName + ": I'd like some help.");
				}
				else if (hp > 50) {
					_toolTip.addTip(firstName + ": I need you.");
				}
				else if (hp > 10) {
					_toolTip.addTip(firstName + ": I can't do this!");
				}
				StatusBar.showStatus(firstName + " is about " + Math.floor(dilation).toString() + "cm dilated (" + Constant.getDilationString(dilation) + ")");
			}
		}
		
		
		private function removeToolTip(e:MouseEvent):void {
			switch (_status) {
				case Constant.LADYSTATUS_ALIVE_CORDCUT:
					//circle.removeEventListener(MouseEvent.ROLL_OVER, displayToolTip);
					//cervix.removeEventListener(MouseEvent.ROLL_OVER, displayToolTip);
					//circle.removeEventListener(MouseEvent.ROLL_OUT, removeToolTip);
					//cervix.removeEventListener(MouseEvent.ROLL_OUT, removeToolTip);
					removeEventListener(MouseEvent.MOUSE_DOWN, cutBabyHandler);
					removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
					// ... fall through ...
				case Constant.LADYSTATUS_ALIVE_HADBABY:
					if (contains(scissors)) {
						removeChild(scissors);
						Mouse.show();
					}
					// ... fall through ...
				case Constant.LADYSTATUS_ALIVE_INLABOR:
					if (_toolTip) _toolTip.clearTip();
					break;
				case Constant.LADYSTATUS_DEAD:
					break;
				default:
					if (_toolTip) _toolTip.clearTip();
					trace("Unknown status the lady is in: " + _status);
					break;
			}
		}
	}
}