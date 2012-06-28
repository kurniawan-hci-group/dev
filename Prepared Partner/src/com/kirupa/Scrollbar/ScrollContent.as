package com.kirupa.Scrollbar
{
	import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
	import flash.events.Event;
    import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.events.DataEvent;

    public class ScrollContent extends Sprite
    {
        // elements
        protected var content:Sprite;
        protected static var scrollbar:Scrollbar;
        protected var contentHeight:Number;
		private var _height:Number;
		private static var _visibleLines:int;
        
		protected static var clip:TextField;
        /**
         * Constructor
         */
        public function ScrollContent(_root:DisplayObjectContainer, tf:TextField, scrollRect:Rectangle )
        {
			clip = tf;
			_visibleLines = 1;
			
			content = new Sprite();
			content.addChild(clip);
            contentHeight = clip.height;
            content.scrollRect = scrollRect;
            
            scrollbar = new Scrollbar();
			scrollbar.x = _root.stage.width - scrollbar.width;
			scrollbar.y = 0;
            scrollbar.addEventListener( SliderEvent.CHANGE, updateContent );
			
			_root.addChild(content);
			_root.addChild(scrollbar);
			
			_height = _root.stage.height;
        }
        
        public function updateContent( e:SliderEvent ):void
        {
            var scrollable:Number = contentHeight - content.scrollRect.height;
            var sr:Rectangle = content.scrollRect.clone();

            sr.y = scrollable * e.percent;
            content.scrollRect = sr;
        }
		public static function appendContent(words:String):void {

			// How many lines are we adding?
			var numlines_before:int = clip.numLines;
			// appendText is text only
			clip.appendText(words + "\n");
			//clip.htmlText += htmlwords;
			var numlines_after:int = clip.numLines;
			
			var lines:int = numlines_after - numlines_before;
			_visibleLines += lines;
			
			// If many more lines added, scroll text field
			// about 44 lines on the screen - should not be static... but oh well
			if (_visibleLines > 45) {
				// For every two lines added over the bottom
				for (var i:int = 0; i < lines; i++) {
					// Scroll by 1% - also should not be static
					_visibleLines -= 2;
					scrollbar.dispatchEvent(new SliderEvent(SliderEvent.CHANGE, (scrollbar.percent += 0.01)));
				}
			}
		}
    }
}
