package birth.trainer
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Timer;
	import birth.trainer.Lady;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent
	import flash.text.*;
	import flash.display.*;
	import com.dVyper.utils.*;
	import com.onebyonedesign.ui.*;
	import birth.ui.*;
	import com.kirupa.Scrollbar.*;
	
	/**
	 * ...
	 * @author fire
	 */
	public class Splash extends Sprite 
	{
		
		private var bar:ActionBar;
		private var ladies:LadyContainer;
		
		private var splash_wrapper:Sprite = new Sprite();
		private var splash_bitmap:Bitmap;
		private var help_wrapper:Sprite = new Sprite();
		private var help_bitmap:Bitmap;
		private var helpicon_wrapper:Sprite = new Sprite();
		private var helpicon_bitmap:Bitmap;
		private var playicon_wrapper:Sprite = new Sprite();
		private var playicon_bitmap:Bitmap;
		private var backicon_wrapper:Sprite = new Sprite();
		private var backicon_bitmap:Bitmap;
		private var lady1_bitmap:Bitmap;
		private var lady2_bitmap:Bitmap;
		private var lady3_bitmap:Bitmap;
		private var lady4_bitmap:Bitmap;
		private var lady1_wrapper:Sprite = new Sprite();
		private var lady2_wrapper:Sprite = new Sprite();
		private var lady3_wrapper:Sprite = new Sprite();
		private var lady4_wrapper:Sprite = new Sprite();
		
		private var time:Timer;
		
		// For the tooltip
		private var _toolTip:OBO_ToolTip;
		
		// Status window
		private var _status_window:TextField = new TextField();
		private var _debug_play_link:TextField = new TextField();

		public function Splash():void {
			if (stage) init_splash();
			else addEventListener(Event.ADDED_TO_STAGE, init_splash);
		}
		
		private function init_splash(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, show_splash);
			
			splash_bitmap = new AssetManager.splash1() as Bitmap;
//			helpicon_bitmap = new AssetManager.helptexticon() as Bitmap;
			playicon_bitmap = new AssetManager.playtexticon() as Bitmap;
			_debug_play_link.text = "Skip tutorial >";
			help_bitmap = new AssetManager.helpscreen1() as Bitmap;
			backicon_bitmap = new AssetManager.backtexticon() as Bitmap;
			
//			lady1_bitmap = new AssetManager.icon_lady1() as Bitmap;
//			lady2_bitmap = new AssetManager.icon_lady2() as Bitmap;
//			lady3_bitmap = new AssetManager.icon_lady3() as Bitmap;
//			lady4_bitmap = new AssetManager.icon_lady4() as Bitmap;

			// background
			var matrix:Matrix=new Matrix();
			matrix.createGradientBox(stage.stageWidth,stage.stageHeight,-Math.PI/4);
			graphics.beginGradientFill(GradientType.LINEAR,[0xF5F6CE,0xFBFBEF],[100,100],[0x00,0xFF],matrix);
			graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			graphics.endFill();

			show_splash();
		}
		
		private function show_splash(e:Event = null):void {
			removeSplashAssets();
			
			splash_wrapper.addChild(splash_bitmap);
			addChild(splash_wrapper);

//			helpicon_wrapper.addChild(helpicon_bitmap);
//			addChild(helpicon_wrapper);
//			helpicon_wrapper.x = stage.stageWidth >> 1;
//			helpicon_wrapper.y = stage.stageHeight >> 1;
//			helpicon_wrapper.addEventListener(MouseEvent.CLICK, show_how_to_play);

/*			lady1_wrapper.addChild(lady1_bitmap);
			lady2_wrapper.addChild(lady2_bitmap);
			lady3_wrapper.addChild(lady3_bitmap);
			lady4_wrapper.addChild(lady4_bitmap);
			lady1_wrapper.addEventListener(MouseEvent.CLICK, play1);
			lady2_wrapper.addEventListener(MouseEvent.CLICK, play2);
			lady3_wrapper.addEventListener(MouseEvent.CLICK, play3);
			lady4_wrapper.addEventListener(MouseEvent.CLICK, play4);
			addChild(lady1_wrapper);
			addChild(lady2_wrapper);
			addChild(lady3_wrapper);
			addChild(lady4_wrapper);
			lady1_wrapper.x = 323;
			lady2_wrapper.x = lady1_wrapper.x + lady1_wrapper.width + 6;
			lady3_wrapper.x = lady1_wrapper.x;
			lady4_wrapper.x = lady3_wrapper.x + lady3_wrapper.width + 6;
			lady1_wrapper.y = 366;
			lady2_wrapper.y = lady1_wrapper.y;
			lady3_wrapper.y = lady1_wrapper.y + lady1_wrapper.height + 6;
			lady4_wrapper.y = lady3_wrapper.y;*/
			
			playicon_wrapper.addChild(playicon_bitmap);
//			playicon_wrapper.addChild(_debug_play_link);
			addChild(playicon_wrapper);
			playicon_wrapper.x = 400;
			playicon_wrapper.y = 400;
			_debug_play_link.x = playicon_wrapper.width;
			_debug_play_link.y = playicon_wrapper.height;
//			_debug_play_link.x = (stage.stageWidth - _debug_play_link.width);
//			_debug_play_link.y = (stage.stageHeight - _debug_play_link.textHeight);// + helpicon_bitmap.height;
			playicon_wrapper.addEventListener(MouseEvent.CLICK, play1);

			trace("Splash screen!");
		}
		private function skiptutorial(e:MouseEvent):void {
			init(null, 0);
		}
		private function play1(e:MouseEvent):void {
			init(null, 1);
		}
		private function play2(e:MouseEvent):void {
			init(null, 2);
		}
		private function play3(e:MouseEvent):void {
			init(null, 3);
		}
		private function play4(e:MouseEvent):void {
			init(null, 4);
		}
		private function removeSplashAssets():void {
			if (contains(help_wrapper)) removeChild(help_wrapper);
			if (contains(playicon_wrapper)) removeChild(playicon_wrapper);
			if (contains(helpicon_wrapper)) removeChild(helpicon_wrapper);
			if (contains(splash_wrapper)) removeChild(splash_wrapper);
			if (contains(backicon_wrapper)) removeChild(backicon_wrapper);
			if (contains(lady1_wrapper)) removeChild(lady1_wrapper);
			if (contains(lady2_wrapper)) removeChild(lady2_wrapper);
			if (contains(lady3_wrapper)) removeChild(lady3_wrapper);
			if (contains(lady4_wrapper)) removeChild(lady4_wrapper);
		}
		
		private function show_game_over():void {
			
		}

		private function init(e:Event = null, n:int = 0):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.removeEventListener(MouseEvent.CLICK, init);
			removeSplashAssets();

			// Main
			new Main(stage, n);
		}
	}
}