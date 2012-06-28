package birth.ui {
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.display.Sprite;
	
    public class Nameplate extends Sprite {
		private var _textfield:TextField;
		private var _root:DisplayObjectContainer;

		// constructor
		public function Nameplate(
			root:DisplayObjectContainer,
			words:String,
			xpos:int = 0,
			ypos:int = 0,
			background:Boolean = false,
			bold:Boolean = false,
			multiline:Boolean = false,
			autosize:Boolean = true,
			textcolor:int = 0x0,
			textsize:int = 12
			) {

			var format:TextFormat = new TextFormat();
			format.font    = "Tahoma";
			format.color   = textcolor;
			format.size    = textsize;
			format.bold    = bold;
			
			_textfield = new TextField();
			_textfield.background       = background;
			_textfield.backgroundColor  = 0xFFFFFF;

			if (autosize) {
				_textfield.width = _textfield.height = 1;
				_textfield.autoSize = TextFieldAutoSize.CENTER;
			}
			_textfield.defaultTextFormat = format;
			_textfield.mouseEnabled      = false;
			_textfield.selectable        = false;
			_textfield.x = xpos;
			_textfield.y = ypos;
			_textfield.text = words;

			root.addChild(_textfield);	
			_root = root;
		}
		public function removeNameplate():void {
			_root.removeChild(_textfield);
		}
		public function updateText(newText:String):void {
			_textfield.text = newText;
		}

	}
}