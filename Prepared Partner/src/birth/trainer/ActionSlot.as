package birth.trainer {
	import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
	import flash.events.TimerEvent;
	import flash.geom.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.filters.DropShadowFilter;
	import flash.utils.Timer;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterType;
	import com.onebyonedesign.ui.OBO_ToolTip;
	import birth.ui.*;

	public class ActionSlot extends Sprite{

		// Inside the action card
		private var _actionCard:ActionCard;
		private var n:int;
		private var locked:Boolean;
		private var selected:Boolean;
		private var _active:Boolean;		// For global cooldown

		// Visual stuff
		private var selectedSlot:Shape = new Shape();
        private var icon:Sprite = new Sprite();
		private var icon_b:Bitmap;
		private var lock_b:Bitmap;
		private var lock_wrapper:Sprite = new Sprite();
		private var cooldown_in:Timer;
		
		private var _arrow_icons:Sprite = new Sprite();
		private var _arrow_text_e:TextField;
		private var _arrow_text_p:TextField;
		private var _arrow_text_c:TextField;
		private var _arrow_text_s:TextField;

		private var e_arrow_red_up:Bitmap;
		private var e_arrow_red_down:Bitmap;
		private var e_arrow_green_down:Bitmap;
		private var e_arrow_green_up:Bitmap;
		private var e_arrow_space:Bitmap;
		private var p_arrow_red_up:Bitmap;
		private var p_arrow_red_down:Bitmap;
		private var p_arrow_green_down:Bitmap;
		private var p_arrow_green_up:Bitmap;
		private var p_arrow_space:Bitmap;
		private var c_arrow_red_up:Bitmap;
		private var c_arrow_red_down:Bitmap;
		private var c_arrow_green_down:Bitmap;
		private var c_arrow_green_up:Bitmap;
		private var c_arrow_space:Bitmap;
		private var s_arrow_red_up:Bitmap;
		private var s_arrow_red_down:Bitmap;
		private var s_arrow_green_down:Bitmap;
		private var s_arrow_green_up:Bitmap;
		private var s_arrow_space:Bitmap;
		
		private var _arrow_energy:Bitmap;
		private var _arrow_phys:Bitmap;
		private var _arrow_cog:Bitmap;
		private var _arrow_str:Bitmap;

		private var _size:uint         = 66;
		private var _gutter:uint	   = 8;
		private var _selectColor:uint  = 0x0;
		private var _hoverColor:uint   = 0xFFFF66;
		private var _hoveralpha:Number = 0.3;
		private var _ds:DropShadowFilter;
		private var _hoverShadow:DropShadowFilter;
		private var _hoverTimer:Timer;
		
		private var xAnchor:int;
		private var yAnchor:int;
		
		private var channel:SoundChannel;
		
		private var firstDeal:Boolean;
		
		// constructor
		public function ActionSlot(number:int) {

			n = number;
			name = "ActionSlot" + number;
			locked      = false;
			_actionCard  = null;

			activateSlot();
			firstDeal = true;
			
			selected    = false;
			selectedSlot.name = "SelectedSlot" + number;
			
			trace(this.name + ": Making slot " + name);
			doDrawSlot();

			icon_b = new AssetManager.icon_x();
			icon.addChild(icon_b);

			_arrow_icons.y    = icon.height + _gutter;
			_arrow_icons.x    = 0;
			
			makeArrows();

			// Play the sound after a small delay
			_hoverTimer = new Timer(350, 1);
			
			_ds = new DropShadowFilter(3, 45, 0x000000, .7, 2, 2, 1, 3);
			_hoverShadow = new DropShadowFilter(7, 45, 0x000000, .7, 2, 2, 1, 3);

			new Nameplate(this, (number + 1).toString(), -1, -1, true, true);
			
			// The layers will appear in this order
			addChild(selectedSlot);
			addChild(icon);
		}

		private function makeArrows():void {
			e_arrow_green_up   = new AssetManager.icon_arrowu_green() as Bitmap;
			e_arrow_red_down   = new AssetManager.icon_arrowd_red() as Bitmap;
			e_arrow_space      = new AssetManager.icon_arrow_space() as Bitmap;
			p_arrow_green_up   = new AssetManager.icon_arrowu_green() as Bitmap;
			p_arrow_red_down   = new AssetManager.icon_arrowd_red() as Bitmap;
			p_arrow_space      = new AssetManager.icon_arrow_space() as Bitmap;
			c_arrow_green_up   = new AssetManager.icon_arrowu_green() as Bitmap;
			c_arrow_red_down   = new AssetManager.icon_arrowd_red() as Bitmap;
			c_arrow_space      = new AssetManager.icon_arrow_space() as Bitmap;
			s_arrow_green_up   = new AssetManager.icon_arrowu_green() as Bitmap;
			s_arrow_red_down   = new AssetManager.icon_arrowd_red() as Bitmap;
			s_arrow_space      = new AssetManager.icon_arrow_space() as Bitmap;

			_arrow_energy     = e_arrow_space;
			_arrow_energy.x   = 0;
			_arrow_energy.y   = 0;

			_arrow_phys       = p_arrow_space;
			_arrow_phys.x     = _arrow_energy.width + 4;
			_arrow_phys.y     = 0;

			_arrow_cog        = c_arrow_space;
			_arrow_cog.x      = _arrow_phys.x + _arrow_cog.width + 4;
			_arrow_cog.y      = 0;

			_arrow_str        = s_arrow_space;
			_arrow_str.x      = _arrow_cog.x + _arrow_str.width + 4;
			_arrow_str.y      = 0;

			new Nameplate(_arrow_icons, "E", (_arrow_energy.x + (s_arrow_space.width>>1)), s_arrow_space.height);
			new Nameplate(_arrow_icons, "P", (_arrow_phys.x + (s_arrow_space.width>>1)+3), s_arrow_space.height);
			new Nameplate(_arrow_icons, "C", (_arrow_cog.x + (s_arrow_space.width)), s_arrow_space.height);
			new Nameplate(_arrow_icons, "S", (_arrow_str.x + (s_arrow_space.width)+4), s_arrow_space.height);

			_arrow_icons.addChild(_arrow_energy);
			_arrow_icons.addChild(_arrow_phys);
			_arrow_icons.addChild(_arrow_cog);
			_arrow_icons.addChild(_arrow_str);

		}
		
		public function showArrows(dilation:int):void {	
			if (! contains(_arrow_icons)) {
				addChild(_arrow_icons);
			}
		}
		public function hideArrows():void {
			if (contains(_arrow_icons)){
				removeChild(_arrow_icons);
			}
		}
		public function get size():int {
			return _size;
		}

		public function updateArrows(stageOfLabor:int = Constant.INDEX_EARLY):void {
			var em:EffectMatrix = _actionCard.effectMatrix;
			var e:Effect;
			
			// Handle different dilations
			switch (stageOfLabor) {
				case Constant.INDEX_EARLY:
					e = em.earlyLaborEffects;
					break;
				case Constant.INDEX_ACTIVE:
					e = em.activeLaborEffects;
					break;
				case Constant.INDEX_TRANSITION:
					e = em.transitionEffects;
					break;
				case Constant.INDEX_PUSHING:
					e = em.pushingEffects;
					break;
				case Constant.INDEX_THIRD:
					e = em.thirdStageEffects;
					break;
				
				default:
					trace("Warning: Default case in updateArrows (stageOfLabor: " + stageOfLabor + ")");
					e = em.earlyLaborEffects;
					break;
			}

			// Not valid during this stage of labor
			if (! e.valid) {
				trace("Effect not valid at this stage of labor.");
				_arrow_energy = e_arrow_space;
				_arrow_phys = p_arrow_space;
				_arrow_cog = c_arrow_space;
				_arrow_str = s_arrow_space;
				return;
			}
			
			// Energy
			if (_arrow_icons.contains(_arrow_energy)) {
				_arrow_icons.removeChild(_arrow_energy);
			}
			_arrow_energy = (
				(e.energy > 0)? e_arrow_green_up :
				(e.energy < 0)? e_arrow_red_down :
				e_arrow_space);
			_arrow_icons.addChild(_arrow_energy);
			_arrow_energy.x   = 0;
			_arrow_energy.y   = 0;

			// Physical
			if (_arrow_icons.contains(_arrow_phys)) {
				_arrow_icons.removeChild(_arrow_phys);
			}
			_arrow_phys = (
				(e.physical > 0)? p_arrow_green_up :
				(e.physical < 0)? p_arrow_red_down :
				p_arrow_space);
			_arrow_icons.addChild(_arrow_phys);
			_arrow_phys.x      = _arrow_energy.x + _arrow_phys.width + _gutter;
			_arrow_phys.y      = 0;

			// Cognitive
			if (_arrow_icons.contains(_arrow_cog)) {
				_arrow_icons.removeChild(_arrow_cog);
			}
			_arrow_cog = (
				(e.cognitive > 0)? c_arrow_green_up :
				(e.cognitive < 0)? c_arrow_red_down :
				c_arrow_space);
			_arrow_icons.addChild(_arrow_cog);
			_arrow_cog.x      = _arrow_phys.x + _arrow_cog.width + _gutter;
			_arrow_cog.y      = 0;

			// Strength
			if (_arrow_icons.contains(_arrow_str)){
				_arrow_icons.removeChild(_arrow_str);
			}
			_arrow_str = (
				(e.strength > 0)? s_arrow_green_up :
				(e.strength < 0)? s_arrow_red_down :
				s_arrow_space);
			_arrow_icons.addChild(_arrow_str);
			_arrow_str.x      = _arrow_cog.x + _arrow_str.width + _gutter;
			_arrow_str.y      = 0;

		}
		
		private function disableSlot():void {
			// Deactivate
			trace("Deactivating slot " + name);
			_active = false;
			
			// Remove event listeners
			icon.removeEventListener(MouseEvent.ROLL_OVER, hover);
			icon.removeEventListener(MouseEvent.ROLL_OUT, unhover);
		}
		
		
		// Set the card's icon dynamically, and bring the icon to the background.
		private function setCardIcon(stageOfLabor:int = Constant.INDEX_EARLY, b:Bitmap = null):void {
			// Remove previous icon
			removeChild(this.icon);
			
			// Attach new icon
			if (b == null) {
				icon_b = _actionCard.icon;
			}
			else {
				icon_b = b;
			}
			updateArrows(stageOfLabor);
			
			// Placement
			xAnchor = _gutter >> 1;
			yAnchor = _gutter >> 1;
			icon.x = xAnchor;
			icon.y = yAnchor;

			// Add to the stage in background
			icon.addChild(icon_b);
			addChild(icon);
			setChildIndex(icon, 0);
			setChildIndex(selectedSlot, 0);

			icon.filters = [_ds];

			// Animation
			icon.scaleX = 0.01;
			icon.scaleY = 0.01;
			cooldown_in = new Timer(Constant.SPEED,100);
			cooldown_in.addEventListener(TimerEvent.TIMER, animateCooldown);
			cooldown_in.addEventListener(TimerEvent.TIMER_COMPLETE, animateCooldownComplete);
			
			cooldown_in.start();
		}
		
		// Animate the cooldown
		private function animateCooldown(e:TimerEvent):void {
			icon.scaleX += 0.01;
			icon.scaleY += 0.01;
		}
		// Prevent huge icons
		private function animateCooldownComplete(e:TimerEvent):void {
			icon.scaleX = 1;
			icon.scaleY = 1;
		}
		
		// Start global cooldown timer
		public function globalCooldown(nSeconds:Number = Constant.GLOBAL_COOLDOWN):void {
			new TimeleftCounter(this, nSeconds);
			
			disableSlot();
			
			var t:Timer = new Timer(1000, nSeconds);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, activateSlot);
			t.start();
		}
		
		// Cooldown complete; reactivate slot
		private function activateSlot(e:Event = null):void {
			trace("Activating slot " + name);
			_active = true;

			// Event listeners
			icon.addEventListener(MouseEvent.ROLL_OVER, hover);
			icon.addEventListener(MouseEvent.ROLL_OUT, unhover);
			icon.addEventListener(MouseEvent.MOUSE_DOWN, click);
		}
		
		public function get card():ActionCard {
			return _actionCard;
		}
		public function deal(c:ActionCard, stageOfLabor:int = Constant.INDEX_EARLY):void {

			_actionCard = c;
			trace(name + ": Adding card " + c.actionName);
			
			setCardIcon(stageOfLabor, _actionCard.icon);
			
		}
		
		public function isActive():Boolean {
			return _active;
		}
		
		public function isSelected():Boolean {
			return selected;
		}
		public function select():void {
			selected = true;
			selectedSlot.graphics.beginFill(_selectColor, 1);
            selectedSlot.graphics.drawRect(0, 0, _size+_gutter, _size+_gutter);
			selectedSlot.graphics.endFill();
		}
		public function unselect():void {
			selected = false;
			selectedSlot.graphics.clear();
		}
		private function playSound(e:TimerEvent):void {
			if (channel != null) channel.stop();
			channel = _actionCard.audioCardName.play();
		}
		private function click(event:MouseEvent):void {
			if (channel != null) {
				channel.stop();
			}
//			disableSlot();
		}
		public function hover(event:MouseEvent):void {
			icon.filters = [_hoverShadow];
			icon.x-=2;
			icon.y-=2;

			StatusArea.showStatus(_actionCard.getInfo());
			_hoverTimer.start();
			_hoverTimer.addEventListener(TimerEvent.TIMER_COMPLETE, playSound);
		}
		public function unhover(event:MouseEvent):void {
			if (_hoverTimer != null && _hoverTimer.running) {
				_hoverTimer.reset();
			}
			icon.filters = [_ds];
			icon.x = xAnchor;
			icon.y = xAnchor;
		}
		public function isLockedSlot():Boolean {
			return locked;
		}
		public function lockSlot():void {
			locked = true;
			addChild(lock_wrapper);
		}
		public function unlockSlot():void {
			locked = false;
			removeChild(lock_wrapper);
		}

		public function getInfo():String {
			var s:String = new String(name + ": ");
			if (locked == true) {
				s += "(locked) ";
			}
			s += "\n";
			if (this._actionCard != null) {
				s += "   --> Action card: ";
				s += _actionCard.actionName + " (" + _actionCard.id + ")";
			}
			return s;
		}

		private function doDrawSlot():void {
			selectedSlot.graphics.clear();
        }
	}
}