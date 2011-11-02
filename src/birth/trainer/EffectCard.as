package birth.trainer {
	import flash.display.Bitmap;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Shape;
    import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.Font;
	import birth.ui.*;

    public class EffectCard extends Sprite {
		private var _gutter:uint	  = 2;
		private var _active:Boolean;

		private var _parentLady:Lady; // Pointer to the lady
		private var _actionCard:ActionCard; // Pointer to the card
		private var _actionIcon:Bitmap; // Local copy of the icon
		public var timer:Timer;
		private var animation:Timer;
		private var tlc:TimeleftCounter;
		
		private var _effectRate:int;
		private var _effectDuration:int;
		private var _effectMatrix:EffectMatrix;
		
		private var xdist:int;
		private var ydist:int;
		private var xstep:int;
		private var ystep:int;

		// constructor
		public function EffectCard(l:Lady, c:ActionCard, success:Boolean) {
			name = "EffectCard";

			_parentLady = l;
			_actionCard = c;
			
			// Little version of the action card
			_actionIcon = new Bitmap(c.icon.bitmapData);
			this.addChild(_actionIcon);
			_parentLady.addChild(this);
//			_actionIcon.scaleX = _actionIcon.scaleY = 0.5;
			new Nameplate(this, "Current effect:\n" + c.actionName, (_actionIcon.width >> 1), _actionIcon.height + 3, true);
			
			_effectRate = (c.effectRate + 1) * 100 * Constant.SPEED;
			_effectDuration = Constant.SPEED * c.effectDuration;
//			_effectDuration = Constant.SPEED * ((c.effectDuration <= Constant.TIME_INF)? 
//				Constant.TIME_VLONG :
//				c.effectDuration);
			

			_effectMatrix = _actionCard.effectMatrix;
			
			// Animation
			animation = new Timer(20, 15); // 15 ticks on arc
			animation.addEventListener(TimerEvent.TIMER, animationTick);
			animation.addEventListener(TimerEvent.TIMER_COMPLETE, animationComplete);
			animation.start();

			// Start animation here
			this.x = 0;
			this.y = 150;
			
			// Distance to travel
			xdist = 150; //- startx;
			ydist = 0 - 150;//- starty;
			
			// Number of steps
			xstep = xdist / (animation.repeatCount);
			ystep = ydist / (animation.repeatCount);
			
			this.addEventListener(MouseEvent.ROLL_OVER, hover);
			this.addEventListener(MouseEvent.ROLL_OUT, unhover);
			
			if (success) {
				startEffect();
			}
		}
		
		public function startEffect():void {
			// Start the countdown
			timer = new Timer(_effectRate, _effectDuration);
			timer.addEventListener(TimerEvent.TIMER, effectTick);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, effectComplete);
			timer.start();

			// This effect is active
			_active = true;
			
			// Number of seconds remaining
			tlc = new TimeleftCounter(this, _effectDuration * _effectRate / 1000);

			this.addEventListener(MouseEvent.MOUSE_DOWN, clicked);
		}
		public function get actionName():String {
			return _actionCard.actionName;
		}
		
		private function animationTick(e:TimerEvent):void {
			this.x += xstep;
			this.y += ystep;
		}
		private function animationComplete(e:TimerEvent):void {
//			this.x = 150;
//			this.y = 0;
		}
		public function effectTick(e:TimerEvent):void {
			trace("Tick for " + _parentLady.getFirstName() + ": "  
				+ _actionCard.actionName
				+ " (delay " + timer.delay 
				+ ", " + timer.currentCount 
				+ "/" + timer.repeatCount + ")");
			
			_parentLady.modifyMechanics(_effectMatrix);
		}
		public function isActive():Boolean {
			return _active;
		}
		public function effectComplete(e:TimerEvent):void {
			trace ("Effect is done: " + _actionCard.actionName
				+ " for " +  _parentLady.getFirstName() );
			if (_parentLady.contains(this))	_parentLady.removeChild(this);
			_parentLady.effectComplete(_actionCard.id);
			_active = false;
		}
		public function cancelEffect(reason:String = "No reason given"):void {
			trace("Cancelling " + _parentLady.getFirstName() + "'s " + _actionCard.actionName + " prematurely: " + reason);
			StatsTracker.pushActionCancelled(_actionCard, _parentLady.getDilation(), reason);
			if (timer != null) timer.stop();
			if (tlc != null)   tlc.stopTimer();
			_active = false;
			_parentLady.effectComplete(_actionCard.id);
			if (_parentLady.contains(this))	_parentLady.removeChild(this);
		}
		private function hover(e:MouseEvent):void {
			StatusArea.showStatus("Click to cancel effect: " + _actionCard.getInfo());
		}
		private function clicked(e:MouseEvent):void {
			cancelEffect("User clicked to cancel effect");
		}
		private function unhover(e:MouseEvent):void {
		}
	}
}