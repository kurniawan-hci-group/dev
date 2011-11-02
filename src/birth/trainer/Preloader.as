package birth.trainer
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.StageAlign;
	import flash.display.Stage;
	import flash.display.StageScaleMode;

	/**
	 * ...
	 * @author fire
	 */
	public class Preloader extends MovieClip 
	{
		private var preloader		:Shape;
		private var progressText	:TextField;
		private var infoText		:TextField;
		private var inviteCode      :String;

		public function Preloader() 
		{
			XML.ignoreWhitespace = false;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			// show loader
			
			preloader = new Shape();
			preloader.graphics.beginFill(0xFF0000);
			preloader.graphics.drawRect( -13, -15, 30, 30);
			preloader.graphics.endFill();
			addChild(preloader);
			
			progressText = new TextField();
			var progressTextFormat:TextFormat = new TextFormat("_sans", 16, 0x000000, true);
			progressTextFormat.align = TextFormatAlign.CENTER;
			progressText.defaultTextFormat = progressTextFormat;
			addChild(progressText);
			
			infoText = new TextField();
			infoText.width = 300;
			infoText.defaultTextFormat = progressTextFormat;
			infoText.text = "The Prepared Partner\nPlease wait...";
			addChild(infoText);
			
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		private function onResize(e:Event = null):void {
			if (preloader) {
				preloader.x = stage.stageWidth / 2;
				preloader.y = stage.stageHeight / 2;
			}
			if (progressText) {
				progressText.x = (stage.stageWidth - progressText.width) / 2;
				progressText.y = stage.stageHeight / 2 + 22;
				infoText.x = (stage.stageWidth - infoText.width) / 2;
				infoText.y = stage.stageHeight / 2 - 60;
			}
		}
		
		private function progress(e:ProgressEvent):void {
			// update loader
			if (progressText) {
				progressText.text = Math.round(e.bytesLoaded / e.bytesTotal * 100).toString() + " %";
				trace("Preloader: " + progressText.text);
			}
		}
		
		private function checkFrame(e:Event):void {
			preloader.rotation += 5;
			if (currentFrame == totalFrames) {
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				startup();
			}
		}
		
		private function startup():void {
			// hide loader
			stop();
			removeChild(preloader);
			removeChild(progressText);
			removeChild(infoText);
			preloader = null;
			progressText = null;
			infoText = null;
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			var mainClass:Class = getDefinitionByName("birth.trainer.Splash") as Class;
			addChildAt(new mainClass() as DisplayObject, 0);
		}	
	}
}
