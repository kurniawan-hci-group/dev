package birth.trainer {
    public class Constant {
		public static const MAJORTICK:int			= 800; // Update events in 0.3s
		
		public static const GLOBAL_COOLDOWN:int		= 5; // seconds
		public static const MAX_COOLDOWN:int		= TIME_VLONG*SPEED;
		
		public static const MAX_LADIES:int          = 1;
		public static const MAX_LADIES_PER_ROW:int  = 3;
		
		public static const MAX_ACTION_CARDS:int = 3;
		public static const MAX_EFFECTS:int		 = 15;
		public static const MAX_EFFECTS_PER_ROW:int = 5;
		
		public static const MAX_LOCKED_SLOTS:int	= MAX_ACTION_CARDS - 3;
		
		public static const SPEED:int		= 5;
		
		public static const TIME_INF:int    = 0;
		public static const TIME_SHORT:int  = 2;
		public static const TIME_MED:int    = 3;
		public static const TIME_LONG:int   = 4;
		public static const TIME_VLONG:int  = 5;

		public static const SPEED_IMM:Number   = 0;
//		public static const SPEED_VFAST:Number = 1;
		public static const SPEED_FAST:Number   = 1;
		public static const SPEED_MED:Number  = 2;
		public static const SPEED_SLOW:Number = 3;
		public static const SPEED_VSLOW:Number = 4;

		public static const MAX_DILATION:Number  = 12; // 10 plus pushing
		public static const MIN_DILATION:Number  = 0.5;
		public static const DILATION_ERR:Number  = 0;
		
		public static const DILATION_STEP:Number	= 1;
		public static const DILATION_SMALLSTEP:Number = 0.05;
		public static const DILATION_EARLY:int      = 2;
		public static const DILATION_ACTIVE:int     = 4;
		public static const DILATION_TRANSITION:int = 8;
		public static const DILATION_COMPLETE:int   = 10;
		public static const DILATION_THIRDSTAGE:int = 13;
		
		public static const INDEX_EARLY:int         = 0;
		public static const INDEX_ACTIVE:int        = 1;
		public static const INDEX_TRANSITION:int    = 2;
		public static const INDEX_PUSHING:int       = 3;
		public static const INDEX_THIRD:int         = 4;
		public static const INDEX_UNKNOWNSTAGE:int  = 5;

		// Minimum labor strength
		public static const STRLABOR_EARLY:int      =  5;
		public static const STRLABOR_COMPLETE:int   =  85;
		// Minimum stability
		public static const MIN_STAB_PROGRESS:int   = 250;
		
		public static const STAT_ENERGY:String      = "Energy";
		public static const STAT_PHYSSUPPORT:String = "PhysSupport";
		public static const STAT_COGSUPPORT:String  = "CogSupport";
		public static const STAT_LABORSTR:String    = "LaborStr";
		
		public static const LOCATION_UNKNOWN:int  = 0;
		public static const LOCATION_HOME:int     = 1;
		public static const LOCATION_ROOM:int     = 2;
		public static const LOCATION_TUB:int      = 3;
		public static const LOCATION_SHOWER:int 	= 4;
		public static const LOCATION_LARGETUB:int	= 5;
		public static const LOCATION_GOINGHOME:int	= 6;
		public static const LOCATION_COMINGIN:int	= 7;
		
		public static const CARD_TRASHCAN_ID:int   = 0;
		public static const CARD_GOHOME_ID:int     = 9;
		public static const CARD_DIMLIGHTS_ID:int  = 10;
		public static const CARD_SHOWER_ID:int     = 29;
		public static const CARD_BATH_ID:int       = 30;
		public static const CARD_BIG_BATH_ID:int   = 31;

		public static const TIME_UNTIL_PROGRESS:int = 5;

		public static const LADYSTATUS_ALIVE_HADBABY:uint = 3;
		public static const LADYSTATUS_ALIVE_CORDCUT:uint = 2;
		public static const LADYSTATUS_ALIVE_INLABOR:uint = 1;
		public static const LADYSTATUS_DEAD:uint          = 0;
		
/*		// Action categories:
// 1   1   1   1   1   1   1   1 , 1   1   1   1 , 1   1   1   1
//                                         |   |   |   |   |   |
		// Massage / touch ----------------+   |   |   |   |   |
		// Rest / energy  ---------------------+   |   |   |   |
		// Environment ----------------------------+   |   |   |
		// Focus / distraction ------------------------+   |   |
		// Pain relief ------------------------------------+   |
		// Moving the baby ------------------------------------+
		public static const A_MASSAGE_TOUCH:uint     = 0x20;
		public static const A_REST_ENERGY:uint       = 0x10;
		public static const A_ENVIRONMENT:uint       = 0x08;
		public static const A_FOCUS_DISTRACTION:uint = 0x04;
		public static const A_PAIN_RELIEF:uint       = 0x02;
		public static const A_MOVING_BABY:uint       = 0x01;
		public static const A_OTHER:uint             = 0x00;
		
// All of labor
// x   x   x   3 , P  10  9   8 , 7   6   5   4 , 3   2   1   0
		public static const LABOR_EARLY:uint         = 0x00f;
		public static const LABOR_ACTIVE:uint        = 0x0f0;
		public static const LABOR_TRANSITION:uint    = 0x070;
		public static const LABOR_PUSHING:uint       = 0x080;
		public static const LABOR_THIRD_STAGE:uint   = 0x100;
		public static const LABOR_NONE:uint          = 0x000;

		public static const LABOR_EARLYACTIVE:uint   = LABOR_EARLY | LABOR_ACTIVE;
		public static const LABOR_ACTIVETRANS:uint   = LABOR_ACTIVE | LABOR_TRANSITION;
		public static const LABOR_LATE:uint          = LABOR_TRANSITION | LABOR_PUSHING;
		public static const LABOR_ALL:uint	= LABOR_EARLY | LABOR_ACTIVE | LABOR_TRANSITION | LABOR_PUSHING;
*/
		
		public static function getStageOfLabor(dilation:Number):int {
			if (dilation < DILATION_ACTIVE) {
				return INDEX_EARLY;
			}
			else if (dilation < DILATION_TRANSITION) {
				return INDEX_ACTIVE;
			}
			else if (dilation < DILATION_COMPLETE) {
				return INDEX_TRANSITION;
			}
			else if (dilation < DILATION_THIRDSTAGE) {
				return INDEX_PUSHING;
			}
			else return INDEX_THIRD;
		}
		public static function getDilationString(n:Number):String {
			if (n > Constant.DILATION_COMPLETE) {
				return "pushing";
			}
			else if (n >= DILATION_TRANSITION) {
				return "transition";
			}
			else if (n >= DILATION_ACTIVE) {
				return "active labor";
			}
			else {
				return "early labor";
			}
		}
		public static function getTimeString(n:Number):String {
			switch (n) {
				case Constant.TIME_SHORT:
					return "SHORT";
					break;
				case Constant.TIME_MED:
					return "MEDIUM";
					break;
				case Constant.TIME_LONG:
					return "LONG";
					break;
				case Constant.TIME_VLONG:
					return "VERY LONG";
					break;
				case Constant.TIME_INF:
					return "INFINITE";
					break;
				default:
					return "UNKNOWN TIME";
					break;
			}
		}
		public static function getSpeedString(n:Number):String {
			switch (n) {
				case Constant.SPEED_IMM:
					return "IMMEDIATE";
					break;
				case Constant.SPEED_SLOW:
					return "SLOW";
					break;
				case Constant.SPEED_MED:
					return "MEDIUM";
					break;
				case Constant.SPEED_FAST:
					return "FAST";
					break;
				case Constant.SPEED_VSLOW:
					return "VERY SLOW";
					break;
				default:
					return "UNKNOWN SPEED";
					break;
			}
		}
		public static function stringToEffect(s:String):Number {
			var r:Number;
			
			if (s == "") r = 0;
			else if (s == "1" || s == "V") r = 1; // valid
			else if (s == "U") r = 1;
			else if (s == "UU") r = 2;
			else if (s == "UUU") r = 3;
			else if (s == "UUUU") r = 4;
			else if (s == "D") r = -1;
			else if (s == "DD") r = -2;
			else if (s == "DDD") r = -3;
			else if (s == "DDDD") r = -4;
			else r = 0;
			return r;
		}
		public static function effectToString(n:Number):String {
			var s:String = new String();
			var i:int;
			if (n == 0) s = "";
			else if (n < 0) {
				for (i = 0; i < -n; i++) {
					s += "D";
				}
			}
			else if (n > 0) {
				for (i = 0; i < n; i++) {
					s += "U";
				}
			}
			return s;
		}
		public static function speedToNumber(s:String):Number {
			if (s == null) return SPEED_MED;
			if (s == "IMM") return SPEED_IMM;
			if (s == "FAST") return SPEED_FAST;
			if (s == "MED") return SPEED_MED;
			if (s == "SLOW") return SPEED_SLOW;
			if (s == "VSLOW") return SPEED_VSLOW;
			else return SPEED_MED;
		}
		public static function timeToNumber(s:String):Number {
			if (s == null) return TIME_MED;
			if (s == "INF") return TIME_INF;
			if (s == "SHORT") return TIME_SHORT;
			if (s == "MED") return TIME_MED;
			if (s == "LONG") return TIME_LONG;
			if (s == "VLONG") return TIME_VLONG;
			else return TIME_MED;
		}
	}
}