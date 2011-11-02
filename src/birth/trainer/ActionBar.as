package birth.trainer {
	import flash.display.Bitmap;
	import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Shape;
    import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundChannel;
	import flash.sampler.NewObjectSample;
	import flash.text.engine.BreakOpportunity;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.Font;
	import flash.utils.Timer;
	import flash.filters.DropShadowFilter;
	import com.onebyonedesign.ui.OBO_ToolTip;
	import birth.ui.*;
	
    public class ActionBar extends Sprite {
		private const LOCK_ENABLED:Boolean = false;

		private var slots:Array;
		private var actionDeck:ActionDeck;
		private var selectedSlot:ActionSlot = null;

		private var hoveredAction:ActionCard = null;

		private var len:Number = 400;
		private var wid:Number = 80;
		
		private static var instancenumber:int = 0;
		private const bgColor:uint        = 0xEEEEEE;
		private const mouseoverColor:uint = 0x888800;
		private var selectedColor:uint  = 0xFFFF00;
		private var borderColor:uint    = 0x000000;
		private var borderSize:uint     = 2;
		private var cornerRadius:uint   = 9;
		private var gutter:uint         = 20;
		private var _hoverColor:uint  = 0xFFFF66;
		private var _hoveralpha:Number = 0.3;
		private var _size:uint        = 66;
		private var _gutter:uint	  = 3;

		private var trashcan_wrapper:Sprite = new Sprite();
		private var trashcan:Bitmap;
		private var trashcan_active:Boolean;
		private var _ds:DropShadowFilter;
		private var _hoverShadow:DropShadowFilter;

		private var biglock_wrapper:Sprite = new Sprite();
		private var biglock:Bitmap;
 		private var biglock_hovering:Shape = new Shape();
		private var biglock_selected:Bitmap;
		private var lockSelected:Boolean = false;
		private var numLockedSlots:int = 0;

		private var _icon_arrowu_red:Bitmap;
		private var _icon_arrowu_green:Bitmap;
		private var _icon_arrowd_red:Bitmap;
		private var _icon_arrowd_green:Bitmap;

		private var _timeleftText:TextField = new TextField();
		
		
		// For the tooltip
		private var _toolTip:OBO_ToolTip;

		// constructor
		public function ActionBar(n:int=5) {
			name = "ActionBar" + instancenumber;
			actionDeck = new ActionDeck();
			
			slots = new Array();

			if (n >= Constant.MAX_ACTION_CARDS) {
				n = Constant.MAX_ACTION_CARDS;
			}

			// Tool tips
			_toolTip = OBO_ToolTip.createToolTip(this);

			// Make new action slots
			for (var i:int = 0; i < n; i++) {
				slots[i] = new ActionSlot(i);
				slots[i].addEventListener(MouseEvent.ROLL_OVER, displayToolTip);
				slots[i].addEventListener(MouseEvent.ROLL_OUT, removeToolTip);
				slots[i].addEventListener(MouseEvent.MOUSE_DOWN, selectCardHandler);
				addChild(slots[i]);
			}
			name = "TheBar";
			trace(name + ": New bar with " + slots.length + " slots.\n");
			
			// place the action slots on the stage
			var slotsize:Number = slots[0].size;
			for (i = slots.length - 1; i >= 0; i--) {
				slots[i].x = len - (slots.length - i) * wid + gutter;
				slots[i].y = Math.floor((wid - slotsize) / 2);
			}

			// Draw trash can and locks
			drawTrashcanAndLock();

			// Populate the action slots
			deal();


			for (i = 0; i < slots.length; i++) {
				trace(name + ": " + "[" + i + "]: " + slots[i].getInfo());
			}
		}

		// Place an action card into each action slot, or into dealSlot, if specified
		public function deal(dealslot:ActionSlot = null, stageOfLabor:int = Constant.INDEX_EARLY):void {
			var thisslot:ActionSlot;

			if (dealslot == null) {
				for each (var v:ActionSlot in slots) {
					if (v.isLockedSlot() != true) {
						v.deal(actionDeck.nextAction(), stageOfLabor);
//						v.setCardIcon();
						trace(name + ": Adding card to slot " + v.name);
					}
					else {
						trace(name + ": Unable to deal to locked slot " + v.name);
					}
				}
			}
			else {
				if (dealslot.isLockedSlot() != true) {
					// Discard current card first
					
					dealslot.deal(actionDeck.nextAction(), stageOfLabor);
//					dealslot.setCardIcon();
					trace(name + ": Adding card to selected slot " + dealslot.name);
				}
				else {
					trace(name + ": Unable to deal card to locked slot " + dealslot.name);
				}
			}
			
		}
		
		// Draw the trash can and lock icons
		private function drawTrashcanAndLock():void {
			
			// Add a trash can icon	
			trashcan_active = true;
			trashcan = new AssetManager.icon_trashcan();
			trashcan.name = "trashcan";
			trashcan_wrapper.addChild(trashcan);
			trashcan_wrapper.name = "trashcan_wrapper";
			addChild(trashcan_wrapper);
			trashcan_wrapper.addEventListener(MouseEvent.MOUSE_DOWN, trashnow);
			trashcan_wrapper.addEventListener(MouseEvent.ROLL_OVER, trashhover);
			trashcan_wrapper.addEventListener(MouseEvent.ROLL_OUT,  trashunhover);

			_ds = new DropShadowFilter(3, 45, 0x000000, .7, 2, 2, 1, 3);
			_hoverShadow = new DropShadowFilter(7, 45, 0x000000, .7, 2, 2, 1, 3);
			trashcan_wrapper.filters = [_ds];

			// Add a lock icon
			if (LOCK_ENABLED) {
				biglock = new AssetManager.icon_lock_large();
				biglock.name = "biglock";
				biglock_wrapper.addChild(biglock);
				biglock_wrapper.name = "biglock_wrapper";
				biglock_hovering.graphics.clear();
				biglock_hovering.name = "biglock_hovering";
				biglock_selected = new AssetManager.icon_lock_large_selected();
				biglock_selected.name = "biglock_selected";
				addChild(biglock_wrapper);
				addChild(biglock_hovering);
				biglock_wrapper.addEventListener(MouseEvent.ROLL_OVER, lockHover);
				biglock_wrapper.addEventListener(MouseEvent.ROLL_OUT, lockUnhover);
				biglock_wrapper.addEventListener(MouseEvent.MOUSE_DOWN, lockClick);
			}

			var trashy:int;
			
			if (LOCK_ENABLED) trashy = (trashcan_wrapper.height) >> 1;
			else              trashy = 0;
			trashcan_wrapper.x = len + 2*gutter;
			trashcan_wrapper.y = trashy;
			
			if (LOCK_ENABLED) {
				biglock_wrapper.x = len + 2*gutter;
				biglock_wrapper.y = -trashy;
				biglock_hovering.x = biglock_wrapper.x;
				biglock_hovering.y = biglock_wrapper.y;
			}
		}
		public function updateArrows(stageOfLabor:int):void {
			for each (var s:ActionSlot in slots) {
				s.updateArrows(stageOfLabor);
			}
		}
		public function keyPressed(slot:int):void {
			// select the slot
			if (slot > 0 && slot <= slots.length){
				selectCard(slots[slot - 1]);
			}
			// shift key pressed (lock the slot)
			else if (slot > 10 && slot <= (slots.length + 10)) {
				if (LOCK_ENABLED) {
					toggleLock(slots[(slot - 11)]);
				}
			}
			
			else if (slot == 0) {
				trashcan_wrapper.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			}
			
			else if (slot == -1) {
				if (LOCK_ENABLED) {
					biglock_wrapper.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
				}
			}
		}
		
		// Getter for the selected action
		public function getSelectedAction():ActionCard {
			if (selectedSlot != null)
				return selectedSlot.card;
			else return null;
		}
		
		// Getter for the selected slot
		public function getSelectedSlot():ActionSlot {
			return selectedSlot;
		}
		
		// Deal into the selected slot
		public function dealSlot(stageOfLabor:int = Constant.INDEX_EARLY):void {
			if (selectedSlot != null && selectedSlot.isLockedSlot() != true) {
				deal(selectedSlot, stageOfLabor)
			}
		}
		
		// Unlock the slot
		public function unlockSlot(slot:ActionSlot):void {
			if (LOCK_ENABLED) {
				if (numLockedSlots >= 0) {
					trace ("Unlocking slot " + slot.card.actionName);
					slot.unlockSlot();
					numLockedSlots--;
				}
				else trace ("Unable to unlock slot: #locked=" + numLockedSlots);
				unselectAll();
			}
		}
		
		// Lock the slot
		public function lockSlot(slot:ActionSlot):void {
			if (LOCK_ENABLED) {
				if (numLockedSlots < Constant.MAX_LOCKED_SLOTS) {
					trace ("Locking slot " + slot.card.actionName);
					slot.lockSlot();
					numLockedSlots++;
				}
				else trace ("Unable to lock slot: #locked=" + numLockedSlots);
				unselectAll();
			}
		}

		// Unselect everything... 
		// or if except is provided, skip that slot.
		public function unselectAll(except:ActionSlot = null):void {
			if (except == null) {
				for each (var v:ActionSlot in slots) {
					v.unselect();
				}
				selectedSlot = null;
			}
			else {
				for each (var w:ActionSlot in slots) {
					if (except != w)
						w.unselect();
				}
			}
			if (LOCK_ENABLED) {
				if (lockSelected) {
					unselectLock();
				}
			}
		}


		private function selectCard(s:ActionSlot):void {
			// Make sure it's not on cooldown
			if (s.isActive() == false) {
				return;
			}
			
			// Toggle selection -- enable unselecting the slot
			if (s == selectedSlot) {
				unselectAll();
				return;
			}
			
			// Lock has been waiting for this moment
			// Toggle slot lock
			if (LOCK_ENABLED) {
				if (lockSelected == true) {
					toggleLock(s);
					return;
				}
			}
			selectedSlot = s;
			selectedSlot.select();
			unselectAll(selectedSlot);
		}


		// Select the action card (mouse event)
		public function selectCardHandler(event:MouseEvent):void {
			var s:ActionSlot;
			var b:Boolean = false;
			
			// Action slot selection
			if (event.target is ActionSlot) {
				s = event.target as ActionSlot;
			}
			
			else if (event.target.parent is ActionSlot) {
				s = event.target.parent as ActionSlot;
			}

			// If it's not an action slot, don't process further
			else {
				return;
			}

			// event target is an action slot
			selectCard(s);
		}

		private function toggleLock(s:ActionSlot):void {
			if (LOCK_ENABLED){ 
				// Lock slot
				if (s.isLockedSlot() != true) 
					lockSlot(s);
				// Unlock slot
				else unlockSlot(s);
			}
		}
		private function selectLock():void {
			if (LOCK_ENABLED) {
				lockSelected = true;
				biglock_wrapper.removeChild(biglock);
				biglock_wrapper.addChild(biglock_selected);
			}
		}
		private function unselectLock():void {
			lockSelected = false;
			biglock_wrapper.removeChild(biglock_selected);
			biglock_wrapper.addChild(biglock);
		}

		// onClick handler for trash can
        private function trashnow(event:MouseEvent):void {
			
			// If trash can is inactive (global cooldown has not passed), exit
			if (trashcan_active == false) {
				return;
			}

			// Deactivate
			trashcan_active = false;

			// Deal to all unlocked slots
			deal();
			
			// Unselect any selections
			unselectAll();
			
			// Add a visible cooldown timer
			new TimeleftCounter(trashcan_wrapper, Constant.GLOBAL_COOLDOWN);
			
			for each (var aslot:ActionSlot in slots) {
				if (LOCK_ENABLED) {
					if (aslot.isLockedSlot() != true) {
						aslot.globalCooldown(Constant.GLOBAL_COOLDOWN);
					}
				}
			}

			var t:Timer = new Timer(1000, Constant.GLOBAL_COOLDOWN);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, activateTrash);
			t.start();
		}

		// Global cooldown has passed; activate trash
		private function activateTrash(e:TimerEvent):void {
			trashcan_active = true;
		}
		
        private function trashhover(event:MouseEvent):void {
			trashcan_wrapper.filters = [_hoverShadow];
			trashcan_wrapper.x--;
			trashcan_wrapper.y--;
			_toolTip.addTip("Discard all cards");
		}
        private function trashunhover(event:MouseEvent):void {
			trashcan_wrapper.filters = [_ds];
			trashcan_wrapper.x++;
			trashcan_wrapper.y++;
			_toolTip.clearTip();
		}
        private function lockHover(event:MouseEvent):void {
			if (LOCK_ENABLED) {
				biglock_hovering.graphics.beginFill(_hoverColor, _hoveralpha);
				biglock_hovering.graphics.drawCircle(_size>>1, _size>>1, _size>>1);
				biglock_hovering.graphics.endFill();
				
				_toolTip.addTip("Lock up to " + (Constant.MAX_LOCKED_SLOTS - numLockedSlots) + " slots.");
			}
		}
        private function lockUnhover(event:MouseEvent):void {
			biglock_hovering.graphics.clear();
			_toolTip.clearTip();
		}
		
		// Lock
        private function lockClick(event:MouseEvent):void {
			if (LOCK_ENABLED) {
				
				if (event.target.name == "biglock_wrapper") {
					
					// Toggle lock -- enable unselecting
					if (lockSelected == true) {
						unselectLock();
						return;
					}
					
					// Apply lock to the selected slot
					if (selectedSlot != null) {
						toggleLock(selectedSlot);
						unselectAll();
					}
					
					// Select the lock and wait for a card to be selected
					else {
						selectLock();
						trace ("Lock lies in wait.");
					}
				}
			}
		}

		public function showArrows(lady:Lady):void {
			if (lady == null) {
				trace("Unable to show arrows for null lady.");
				return;
			}
			
			for each (var s:ActionSlot in slots) {
				s.showArrows(lady.getDilation());
			}
		}
		public function hideArrows():void {
			for each (var s:ActionSlot in slots) {
				s.hideArrows();
			}
		}
		private function displayToolTip(event:MouseEvent):void {
		}
		private function removeToolTip(event:MouseEvent):void {
		}
	}
}