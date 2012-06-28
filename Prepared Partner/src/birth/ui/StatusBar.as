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

    public class StatusBar {
		private static var _container:Sprite;
		private static var _textfield:TextField;
		private var _root:DisplayObjectContainer;
		private static var _fadeout:Timer;

		// constructor
		public function StatusBar(
			root:DisplayObjectContainer,
			xpos:int,
			ypos:int
			) {
			createTextField(root, xpos, ypos);
		}
		
		private static function createTextField(root:DisplayObjectContainer, xpos:int, ypos:int):void {
			var format:TextFormat = new TextFormat();
			format.font    = "Tahoma";
			format.color   = 0x0;
			format.size    = 12;
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
			_container.x = xpos;
			_container.y = ypos;
			
			_container.addEventListener(MouseEvent.ROLL_OVER, mouseOver);
			_container.addEventListener(MouseEvent.ROLL_OUT, mouseOut);

			_container.addChild(_textfield);
			root.addChild(_container);
			
			_fadeout = new Timer(1000, 5); // 5 seconds until fade
			_fadeout.addEventListener(TimerEvent.TIMER_COMPLETE, beginFade);
			_fadeout.start();
		}
		private static function mouseOver(e:MouseEvent):void {
			_textfield.alpha = 1;
			_fadeout.stop();
		}
		private static function mouseOut(e:MouseEvent):void {
			_fadeout = new Timer(100, 20); // Fade timer
			_fadeout.addEventListener(TimerEvent.TIMER, fadeOut);
			_fadeout.start();
		}
		public static function showStatus(words:String):void {
			if (_textfield == null) {
				throw new Error("StatusBar: instantiate with createTextField() first");
			}
			else {
				_fadeout.stop();
				_textfield.replaceText(0, _textfield.length, words + "\n");
				_textfield.alpha = 1;

				_fadeout = new Timer(1000, 5); // 5 seconds until fade
				_fadeout.addEventListener(TimerEvent.TIMER_COMPLETE, beginFade);
				_fadeout.start();
			}
		}
		private static function beginFade(e:TimerEvent):void {
			_fadeout = new Timer(100, 20); // Fade timer
			_fadeout.addEventListener(TimerEvent.TIMER, fadeOut);
			_fadeout.start();
		}
		private static function fadeOut(e:TimerEvent):void {
			_textfield.alpha -= 0.05;
		}

	}
}