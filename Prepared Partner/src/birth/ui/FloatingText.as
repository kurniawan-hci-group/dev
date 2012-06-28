package birth.ui {
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.display.BlendMode;
	
    public class FloatingText {
		private var _container:Sprite;
		private var _textfield:TextField;
		private var _root:DisplayObjectContainer;
		private var _arc:Timer;

		// constructor
		public function FloatingText (
			root:DisplayObjectContainer,
			words:String,
			color:uint = 0x0000bb, 
			xpos:int = 0,
			ypos:int = 0
			) {
			createTextField(root, words, color, xpos, ypos);
		}
		
		private function createTextField(root:DisplayObjectContainer, words:String, color:uint = 0x00ff00, xpos:int = 0, ypos:int = 0):void {
			var format:TextFormat = new TextFormat();
			format.font    = "Tahoma";
			format.color   = color;
			format.size    = 24;
			format.bold    = false;
			
			_container = new Sprite();
			
			_textfield = new TextField();
			_textfield.background        = false;
			_textfield.backgroundColor   = 0xFFFFFF;
			_textfield.alpha             = 1;
			_textfield.blendMode         = BlendMode.LAYER; // needed for alpha

			_textfield.width             = 300;
			_textfield.height            =  40;
			_textfield.autoSize          = TextFieldAutoSize.CENTER;
			_textfield.defaultTextFormat = format;
			_textfield.mouseEnabled      = false;
			_textfield.selectable        = false;
			_textfield.x = _textfield.y = 0;
			_container.x = xpos;
			_container.y = ypos;
			
			_textfield.text = words;
			
			_container.addChild(_textfield);
			_root = root;
			_root.addChild(_container);
			
			_arc = new Timer(50, 20); // 100 points on the arc
			_arc.addEventListener(TimerEvent.TIMER,          beginArc);
			_arc.addEventListener(TimerEvent.TIMER_COMPLETE, endArc);
			_arc.start();
		}
		private function beginArc(e:TimerEvent):void {
			_container.x += Math.cos(_arc.currentCount) * 4;
			_container.y -= _arc.currentCount;
		}
		private function endArc(e:TimerEvent):void {
			_root.removeChild(_container);
			_container = null;
			_textfield = null;
		}

	}
}