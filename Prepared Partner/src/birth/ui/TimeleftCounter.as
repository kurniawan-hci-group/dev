package birth.ui {
    import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.filters.DropShadowFilter;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
    public class TimeleftCounter extends Sprite {
		private var ticktimer:Timer;

		private var _timeleftText:TextField;
		private var _root:DisplayObjectContainer;
		
		// constructor
		public function TimeleftCounter(root:DisplayObjectContainer, nSeconds:int = 5) {
			_root = root;

			if (nSeconds < 0) {
				nSeconds = 0;
			}

			ticktimer = new Timer(1000, nSeconds);
			ticktimer.start();
			ticktimer.addEventListener(TimerEvent.TIMER, updateTime);
			ticktimer.addEventListener(TimerEvent.TIMER_COMPLETE, effectComplete);

			_timeleftText = new TextField();
			var format:TextFormat = new TextFormat();
			format.font = "Tahoma";
			format.color = 0x0;
			format.size = 9;
			format.bold = true;
			_timeleftText.background = true;
			_timeleftText.backgroundColor = 0xFFFFFF;
			_timeleftText.autoSize = TextFieldAutoSize.LEFT;
			_timeleftText.defaultTextFormat = format;
			_timeleftText.mouseEnabled = false;
			_timeleftText.selectable = false;
			_timeleftText.x = 25;
			_timeleftText.y = 25;
			
			_timeleftText.text = (ticktimer.repeatCount).toString();
			_root.addChild(_timeleftText);
		}
		
		private function updateTime(e:TimerEvent):void {
			if (ticktimer.repeatCount - ticktimer.currentCount < 0) {
				stopTimer();
			}
			_timeleftText.text = (ticktimer.repeatCount - ticktimer.currentCount).toString();
		}
		private function effectComplete(e:TimerEvent):void {
			_root.removeChild(_timeleftText);
		}
		public function stopTimer():void {
			ticktimer.stop();
			if (_root.contains(_timeleftText)){
				_root.removeChild(_timeleftText);
			}
		}
	}
}