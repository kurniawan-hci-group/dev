package birth.trainer {
	import flash.display.Bitmap;
	import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.display.Shape;
	import flash.display.SimpleButton;
    import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import Error;
	import flash.utils.Timer;

    public class ActionCard extends Sprite {

		private var _seed:Number;
		private var _id:uint;
		private var _actionName:String   = new String();
		private var _coolDown:Number;
		private var _effectRate:Number;
		private var _effectDur:Number;
		private var _effectMatrix:EffectMatrix;
		private var _description:String  = new String();
		private var _successRate:Number;
		private var _prosString:String = new String();
		private var _consString:String = new String();
		private var _success1:String;
		private var _success_flavor:String;
		private var _fail1:String;
		private var _fail_flavor:String;
		private var _iconUrl:String = new String();
		private var _iconNumber:Number;
        private var _icon:Bitmap;
		
		private var _invalidString:String;
		private var _audio1Url:String;
		private var _audio2Url:String;
		private var _audio3Url:String;
		private var _audio_cardname:Sound;
		private var _audio_success:Sound;
		private var _audio_failure:Sound;

		// constructor
		public function ActionCard(
				id:Number,
				actionName:String, 
				effectRate:String,
				effectDuration:String,
				coolDown:String, 
				effectMatrix:EffectMatrix,
				successRate:Number,
				description:String,
				prosString:String,
				consString:String,
				invalidString:String,
				success1:String,
				success_flavor:String,
				fail1:String,
				fail_flavor:String,
				iconUrl:String,
				audio1Url:String,
				audio2Url:String,
				audio3Url:String){
//				iconNumber:Number) {

			_seed        = Math.random();
			_id          = id;
			_actionName  = actionName;
			_effectRate  = Constant.speedToNumber(effectRate);
			_effectDur   = Constant.timeToNumber(effectDuration);
			_coolDown    = Constant.speedToNumber(coolDown);
			_effectMatrix = effectMatrix;
			_successRate = (successRate == 0)? 1 : successRate;
			_description = description;			
			_prosString  = prosString;
			_consString  = consString;
			_invalidString = invalidString;
			_iconUrl     = iconUrl;
			_audio1Url   = audio1Url;
			_audio2Url   = audio2Url;
			_audio3Url   = audio3Url;

			_icon = AssetManager.getIcon(iconUrl);
			_audio_cardname = AssetManager.getCardNameSound(iconUrl);
			_audio_success = AssetManager.getResultSound(iconUrl, true);
			_audio_failure = AssetManager.getResultSound(iconUrl, false);

			trace("New action card: " + _actionName + " " + _id + " (seed " + _seed + ")");
		}

		public function reseed():void {
			_seed        = Math.random();
		} 

		// Access functions
		public function get actionName():String {
			return _actionName;
		}
		public function get id():Number {
			return _id;
		}
		public function get seed():Number {
			return _seed;
		}
		public function get coolDown():Number {
			return _coolDown;
		}
		public function get effectRate():Number {
			return _effectRate;
		}
		public function get effectDuration():Number {
			return _effectDur;
		}
		public function get effectMatrix():EffectMatrix {
			return _effectMatrix;
		}
		public function get iconUrl():String {
			return _iconUrl;
		}
		public function get icon():Bitmap {
			return _icon;
		}
		public function get audioCardName():Sound {
			return _audio_cardname;
		}
		public function get audioSuccess():Sound {
			return _audio_success;
		}
		public function get audioFailure():Sound {
			return _audio_failure;
		}
		public function get success():Number {
			return _successRate;
		}
		public function getUsefulBits():Array {
			return _effectMatrix.getUsefulBits();
		}
		/// Play success sound after delay
		public function playAudioSuccess(e:Event = null):void {
			var t:Timer = new Timer(750, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, audioSuccessPlay);
			t.start();
		}
		private function audioSuccessPlay(e:Event = null):void {
			_audio_success.play();
		}
		/// Play failure sound after delay
		public function playAudioFailure(e:Event = null):void {
			var t:Timer = new Timer(750, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, audioFailurePlay);
			t.start();
		}
		private function audioFailurePlay(e:Event = null):void {
			_audio_failure.play();
		}
		public function getFullInfo():String {
			var s:String = new String();

			s += "Name:        " + _actionName + " (" + _id + ")\n";
			s += "Description: " + _description + "\n";
			s += "Pros:        " + _prosString + "\n";
			s += "Cons:        " + _consString + "\n";
			s += "Effect rate: " + Constant.getTimeString(_effectRate) + "\n";
			s += "Effect dr'n: " + Constant.getTimeString(_effectDur) + "\n";
			s += "Cooldown:    "   + Constant.getTimeString(_coolDown) + "\n";
			s += "Invalid:     " + _invalidString + "\n";
			s += "Success:     " + _success1 + "\n";
			s += "Succ flavor: " + _success_flavor + "\n";
			s += "Fail:        " + _fail1 + "\n";
			s += "Fail flavor: " + _fail_flavor + "\n";
			s += "Icon:        " + _iconUrl + "\n";
			s += "Audio 1:     " + _audio1Url + "\n";
			s += "Audio 2:     " + _audio2Url + "\n";
			s += "Audio 3:     " + _audio3Url + "\n";
			s += "Effect matrix: \n" + effectMatrix.getPrintableEffectMatrix();
			return s;
		}
		public function getInfo():String {
			var s:String = new String();
			s += "~ " + _actionName + "~\n";
//			s += "~ " + _actionName + " (" + _id + ") ~ (" + _successRate + ")\n";
			if (_description.length > 0) {
				s += _description + "\n";
			}
			if (_prosString.length > 0) {
				s += "\tPros: \t" + _prosString + "\n";
			}
			if (_consString.length > 0) {
				s += "\tCons: \t" + _consString + "\n";
			}
			return s;
		}
	}
}