package birth.trainer {
	import flash.display.Stage;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	import com.dVyper.utils.dPanel;
	import flash.events.Event;
	
	public class StatsTracker {
		
		private static var _timeEarlyLaborStart:Number  = 0;
		private static var _timeActiveLaborStart:Number = 0;
		private static var _timeTransitionStart:Number  = 0;
		private static var _timePushingStart:Number     = 0;
		private static var _timeOfBirth:Number          = 0;
		private static var _timeOfSection:Number        = 0;
		private static var _timeOfCordCut:Number        = 0;
		
		private static var _inviteCode:String;
		
		private static var _warningsAboutDilationProgress:Number = 0;
		private static var _warningsAboutHpProgress:Number = 0;
		
		private static var _score:Number = 0;
		
		private static var time:Timer;
		
		private static var actionsSuccess:Array;
		private static var actionsFailed:Array;
		private static var actionsCancelled:Array;
		
		public function StatsTracker(stage:Stage) {
			createStatsTracker(stage);
		}
		public static function get inviteCode():String {
			return _inviteCode;
		}
		public static function registerInviteCode(inviteCode:String):void {
			_inviteCode = new String(inviteCode);
		}
		public static function createStatsTracker(stage:Stage):void {
			// dPanel
			//	CREATES A dPanel WHERE YOU PRESS '`' TO SHOW THE dPanel
			dPanel.init(stage, 96, 0x000000, 0.4);
			//	CREATES A GREEN SECTION CALLED 'mousePosition'
			dPanel.addSection('currentTime', 0x00FF00);
			stage.addEventListener(Event.ENTER_FRAME, updateDebugPanel);
			
			_timeActiveLaborStart = 0;
			_timeActiveLaborStart = 0;
			_timeTransitionStart = 0;
			_timePushingStart = 0;
			_timeOfBirth = 0;
			_timeOfSection = 0;
			_score = 0;
			
			_warningsAboutDilationProgress = 0;
			_warningsAboutHpProgress = 0;
			
			actionsFailed = new Array();
			actionsSuccess = new Array();
			actionsCancelled = new Array();
			
			time = new Timer(100);
			time.start();
		}
		
		private static function updateDebugPanel(event:Event):void {
			dPanel.update('currentTime', time.currentCount);
		}
		
		public static function pause():void {
			time.stop();
		}
		public static function play():void {
			time.start();
		}
		public static function timeStageStart(stage:int):void {
			switch (stage) {
				case Constant.INDEX_ACTIVE:
				trace("StatsTracker: Registering active labor time.");
					_timeActiveLaborStart = time.currentCount;
					break;
				case Constant.INDEX_PUSHING:
				trace("StatsTracker: Registering pushing time.");
					_timePushingStart = time.currentCount;
					break;
				case Constant.INDEX_TRANSITION:
				trace("StatsTracker: Registering transition time.");
					_timeTransitionStart = time.currentCount;
					break;
				case Constant.INDEX_THIRD:
				trace("StatsTracker: Registering third stage time.");
					break;
				default:
				trace("StatsTracker: Warning: Unknown stage of labor.");
					break;
			}
		}
		public static function timeOfBirth():void {
			_timeOfBirth = time.currentCount;
		}
		public static function timeofSection():void {
			_timeOfSection = time.currentCount;
		}
		public static function timeOfCordCut():void {
			_timeOfCordCut = time.currentCount;
		}
		public static function addWarningAboutDilationProgress():void {
			_warningsAboutDilationProgress++;
		}
		public static function addWarningAboutHpProgress():void {
			_warningsAboutHpProgress++;
		}
		public static function pushActionSuccess(card:ActionCard, dilation:Number):void {
			actionsSuccess.push({time:time.currentCount, dilation:dilation, card:card, success:true});
		}
		public static function pushActionFailure(card:ActionCard, dilation:Number, reason:String):void {
			actionsFailed.push({time:time.currentCount, dilation:dilation, card:card, reason:reason, success:false});
		}
		public static function pushActionCancelled(card:ActionCard, dilation:Number, reason:String):void {
			actionsCancelled.push({time:time.currentCount, dilation:dilation, card:card, reason:reason, success:true});
		}
		public static function set score(score:Number):void {
			_score = score;
		}
		private static function toArray(o:Object):Array {
			var a:Array = new Array;
			a[0] = o.time;
			a[1] = o.dilation;
			a[2] = o.card.id;
			a[3] = o.card.actionName;
			a[4] = o.success;
			try {
				a[5] = o.reason;
			}
			catch (e:Error) {
			}
			return a;
		}
		private static function toTime(time:int):String {
			var min:String = new String();
			var hr:String = new String();

			hr = Math.floor((time / 100)).toString();
			min = Math.floor((time % 60)).toString();
			return hr + " hours, " + min + " minutes";
		}
		
		public static function getInfo():String {
			var s:String = new String();
			var d:Date = new Date();
			
			var hr:int  = d.getHours();
			var min:int = d.getMinutes();

			var totalActions:int = (actionsSuccess.length + actionsFailed.length);
			var birthTime:int    = (_timeOfSection == 0)? _timeOfBirth : _timeOfSection;

			s = "<b>Game over!</b>\n";
			s += "Score: " + _score + "\n";
			if (_timeOfSection != 0) {
				s += "Time of birth by c-section: " + hr + ":" + 
					((min < 10)? "0" : "") + min + "\n";
			}
			else {
				s += "Time of vaginal birth: " + hr + ":" + 
					((min < 10)? "0" : "") + min + "\n";
			}
			s += "Total time spent in labor: " + toTime(birthTime) + "\n";
			s += "...  early labor: " + 
					toTime((_timeActiveLaborStart > 0)? _timeActiveLaborStart : birthTime) + 
					"\n";
			if (_timeActiveLaborStart > 0) {
				s += "...  active labor: " + 
						toTime(((_timeTransitionStart > 0)? _timeTransitionStart : birthTime) - _timeActiveLaborStart) +
						"\n";
			}
			if (_timeTransitionStart > 0) {
				s += "...  transition: " + 
						toTime((((_timePushingStart > 0)? _timePushingStart : birthTime) - _timeTransitionStart)/10) +
						"\n";
			}
			if (_timePushingStart > 0) {
				s += "...  pushing: " + 
						toTime(birthTime - _timePushingStart) +
						"\n";
			}
			s += "Successful actions: " + actionsSuccess.length + "/" + totalActions;
			s += ((totalActions > 0)? " (" + Math.floor((actionsSuccess.length * 100 / (totalActions))) + "%)\n" :
					"\n");
			return s;
		}
		
		public static function getStatsVariables():URLVariables {
			var v:URLVariables = new URLVariables();
			var d:Date = new Date();
			var hr:int  = d.getHours();
			var min:int = d.getMinutes();

			var totalActions:int = (actionsSuccess.length + actionsFailed.length);
			var birthTime:int    = (_timeOfSection == 0)? _timeOfBirth : _timeOfSection;

			v.inviteCode = _inviteCode;
			v.gameId = Math.floor(Math.random() * 1000 + 1);
			v.currentTime = d.toLocaleString();
			
			v.vaginal = (_timeOfSection == 0)? true: false;
			v.score = _score;
			v.timeOfBirth = hr + ":" + min;
			v.totalTime = birthTime;
			
			v.earlyLabor = (_timeActiveLaborStart > 0)? _timeActiveLaborStart : birthTime;
			
			if (_timeActiveLaborStart > 0) {
				v.activeLabor = ((_timeTransitionStart > 0)? _timeTransitionStart : birthTime) - _timeActiveLaborStart; 
			}
			else {
				v.activeLabor = -1;
			}
			if (_timeTransitionStart > 0) {
				v.transition = ((_timePushingStart > 0)? _timePushingStart : birthTime) - _timeTransitionStart;
			}
			else {
				v.transition = -1;
			}
			if (_timePushingStart > 0) {
				v.pushing = (birthTime - _timePushingStart);
			}
			else {
				v.pushing = -1;
			}
			v.timeOfCordCut = (_timeOfCordCut > 0)? _timeOfCordCut : -1;

			var i:int = 0;
			for each (var o:Object in actionsSuccess) {
				v["successfulActions" + i++ + "[]"] = toArray(o);
			}
			i = 0;
			for each (var p:Object in actionsFailed) {
				v["failedActions" + i++ + "[]"] = toArray(p);
			}
			i = 0;
			for each (var q:Object in actionsFailed) {
				v["cancelledActions" + i++ + "[]"] = toArray(q);
			}
			v.successfulActions = actionsSuccess.length;
			v.totalActions = totalActions;
			v.failedActions = actionsFailed.length;

			v.dilationWarnings = _warningsAboutDilationProgress;
			v.hpWarnings = _warningsAboutHpProgress;
			
			return v;
		}
		
	}
}