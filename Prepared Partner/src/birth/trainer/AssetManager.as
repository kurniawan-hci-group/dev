package birth.trainer {
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.net.URLRequest;

	public final class AssetManager {
		public static var audio_eating_successes:Array = new Array();
		public static var audio_eating_failures:Array = new Array();
		public static var audio_generic_successes:Array = new Array();
		public static var audio_generic_failures:Array = new Array();
		public static var audio_touch_failures:Array = new Array();
		public static var audio_touch_successes:Array = new Array();
		public static var audio_focus_failures:Array = new Array();
		
		public function AssetManager() {
		}

		public static function init():void {
			audio_focus_failures.push(new audio_focus_fail1);
			audio_focus_failures.push(new audio_focus_fail2);
			
			audio_eating_failures.push(new audio_eating_failure1);
			audio_eating_failures.push(new audio_eating_failure2);
			audio_eating_failures.push(new audio_eating_failure3);
			audio_eating_failures.push(new audio_eating_failure4);
			
			audio_eating_successes.push(new audio_eating_success1);
			audio_eating_successes.push(new audio_eating_success2);
			audio_eating_successes.push(new audio_eating_success3);
			
			audio_touch_failures.push(new audio_touch_fail1);
			audio_touch_failures.push(new audio_touch_fail2);
			audio_touch_failures.push(new audio_touch_fail3);

			audio_touch_successes.push(new audio_touch_success1);
			audio_touch_successes.push(new audio_touch_success2);
			audio_touch_successes.push(new audio_touch_success3);
			
			audio_generic_successes.push(new audio_success1);
			audio_generic_successes.push(new audio_success2);
			audio_generic_successes.push(new audio_success3);
			audio_generic_successes.push(new audio_success4);
			audio_generic_successes.push(new audio_success5);
			audio_generic_successes.push(new audio_success6);
			audio_generic_successes.push(new audio_success7);
			audio_generic_successes.push(new audio_success8);
			audio_generic_successes.push(new audio_success9);
			audio_generic_successes.push(new audio_success10);
			audio_generic_successes.push(new audio_success11);
			audio_generic_successes.push(new audio_success12);
			
			audio_generic_failures.push(new audio_general_failure1);
			audio_generic_failures.push(new audio_general_failure2);
			audio_generic_failures.push(new audio_general_failure3);
			audio_generic_failures.push(new audio_general_failure4);
			audio_generic_failures.push(new audio_general_failure5);
			audio_generic_failures.push(new audio_general_failure6);
			audio_generic_failures.push(new audio_general_failure7);
			audio_generic_failures.push(new audio_general_failure8);
			audio_generic_failures.push(new audio_general_failure9);
			audio_generic_failures.push(new audio_general_failure10);
			audio_generic_failures.push(new audio_general_failure11);
			audio_generic_failures.push(new audio_general_failure12);
			audio_generic_failures.push(new audio_general_failure13);
			audio_generic_failures.push(new audio_general_failure14);
			audio_generic_failures.push(new audio_general_failure15);
			audio_generic_failures.push(new audio_general_failure16);
			audio_generic_failures.push(new audio_general_failure17);
			audio_generic_failures.push(new audio_general_failure18);
			audio_generic_failures.push(new audio_general_failure19);
			audio_generic_failures.push(new audio_general_failure20);
			audio_generic_failures.push(new audio_general_failure21);
			audio_generic_failures.push(new audio_general_failure22);
			audio_generic_failures.push(new audio_general_failure23);
			audio_generic_failures.push(new audio_general_failure24);
			audio_generic_failures.push(new audio_general_failure25);
			audio_generic_failures.push(new audio_general_failure26);
		}

		private static function randomSound2(string:String):Sound {
			var soundClass:Class = getDefinitionByName(string) as Class;
			return (new soundClass as Sound);
		}

		private static function randomSound(array:Array):Sound {
			return array[
				Math.round(Math.random() * array.length)
				];
		}
		
		public static function getResultSound(soundURL:String = "", success:Boolean = true):Sound {
			var failureCache:Object = {
				icon00000: new audio_touch_fail1,
				icon00001: new audio_touch_fail2,
				icon00002: new audio00002_f,
				icon00003: new audio00003_f,
				icon00004: new audio00004_f,
				icon00005: new audio00005_f,
				icon00006: new audio00006_f,
				icon00007: new audio_general_failure1,
				icon00008: new audio_touch_fail3,
				icon00009: new audio00009_f,
				icon00010: new audio_touch_fail1,
				icon00011: new audio_focus_fail1,
				icon00014: new audio_touch_fail2,
				icon00015: new audio_touch_fail3,
				icon00016: new audio_general_failure12,
				icon00017: new audio_touch_fail1,
				icon00018: new audio00018_f,
				icon00019: new audio_touch_fail2,
				icon00020: new audio00020_f,
				icon00021: new audio_eating_failure1,
				icon00022: new audio00022_f,
				icon00023: new audio_eating_failure2,
				icon00024: new audio_eating_failure3,
				icon00025: new audio_eating_failure4,
				icon00026: new audio_general_failure18,
				icon00027: new audio_general_failure8,
				icon00028: new audio_general_failure5,
				icon00029: new audio00029_f,
				icon00030: new audio_general_failure14,
				icon00031: new audio_general_failure26,
				icon00032: new audio_general_failure22,
				icon00033: new audio00033_f,
				icon00034: new audio00034_f,
				icon00035: new audio00035_f,
				icon00036: new audio00037_f,
				icon00037: new audio00037_f,
				icon00038: new audio00038_f,
				icon00039: new audio00039_f,
				icon00040: new audio_touch_fail3,
				icon00041: new audio_touch_fail1,
				icon00042: new audio_general_failure6,
				icon00043: new audio_general_failure11,
				icon00044: new audio00044_f,
				icon00045: new audio_general_failure15,
				icon00046: new audio_focus_fail2,
				icon00047: new audio00047_f,
				icon00048: new audio00048_f,
				icon00049: new audio00049_f,
				icon_x:    new audio_x
			};

			var successCache:Object = {
				icon00000: new audio_touch_success1,
				icon00001: new audio_touch_success2,
				icon00002: new audio00002_s,
				icon00003: new audio00003_s,
				icon00004: new audio00004_s,
				icon00005: new audio00005_s,
				icon00006: new audio00006_s,
				icon00007: new audio00007_s,
				icon00008: new audio_touch_success3,
				icon00009: new audio00009_s,
				icon00010: new audio_touch_success1,
				icon00011: new audio00011_s,
				icon00014: new audio_touch_success2,
				icon00015: new audio_touch_success3,
				icon00016: new audio_success1,
				icon00017: new audio_touch_success1,
				icon00018: new audio00018_s,
				icon00019: new audio00019_s,
				icon00020: new audio00020_s,
				icon00021: new audio_eating_success1,
				icon00022: new audio00022_s,
				icon00023: new audio_eating_success2,
				icon00024: new audio_eating_success3,
				icon00025: new audio_eating_success1,
				icon00026: new audio_success3,
				icon00027: new audio_success5,
				icon00028: new audio_success8,
				icon00029: new audio_success12,
				icon00030: new audio_success9,
				icon00031: new audio_success10,
				icon00032: new audio_success6,
				icon00033: new audio_success7,
				icon00034: new audio00034_s,
				icon00035: new audio00035_s,
				icon00036: new audio00036_s,
				icon00037: new audio00037_s,
				icon00038: new audio00038_s,
				icon00039: new audio_success2,
				icon00040: new audio_touch_success2,
				icon00041: new audio_touch_success3,
				icon00042: new audio_success11,
				icon00043: new audio_success4,
				icon00044: new audio_success1,
				icon00045: new audio00045_s,
				icon00046: new audio00046_s,
				icon00047: new audio00047_s,
				icon00048: new audio00048_s,
				icon00049: new audio00049_s,
				icon_x: new audio_x
			};

			var t:Array = soundURL.split(".");
			if (success) {
				// Success sound
				if (t[0] == "")	return new audio_x as Sound;
				return successCache[t[0]] as Sound;
			}
			else {
				// failure messages
				if (t[0] == "")	return new audio_x as Sound;
				return failureCache[t[0]] as Sound;
			}
		}
		public static function getCardNameSound(soundURL:String):Sound {
			var iconNamesCache:Object = {
				icon00000: new audio00000,
				icon00001: new audio00001,
				icon00002: new audio00002,
				icon00003: new audio00003,
				icon00004: new audio00004,
				icon00005: new audio00005,
				icon00006: new audio00006,
				icon00007: new audio00007,
				icon00008: new audio00008,
				icon00009: new audio00009,
				icon00010: new audio00010,
				icon00011: new audio00011,
				icon00014: new audio00014,
				icon00015: new audio00015,
				icon00016: new audio00016,
				icon00017: new audio00017,
				icon00018: new audio00018,
				icon00019: new audio00019,
				icon00020: new audio00020,
				icon00021: new audio00021,
				icon00022: new audio00022,
				icon00023: new audio00023,
				icon00024: new audio00024,
				icon00025: new audio00025,
				icon00026: new audio00026,
				icon00027: new audio00027,
				icon00028: new audio00028,
				icon00029: new audio00029,
				icon00030: new audio00030,
				icon00031: new audio00031,
				icon00032: new audio00032,
				icon00033: new audio00033,
				icon00034: new audio00034,
				icon00035: new audio00035,
				icon00036: new audio00036,
				icon00037: new audio00037,
				icon00038: new audio00038,
				icon00039: new audio00039,
				icon00040: new audio00040,
				icon00041: new audio00041,
				icon00042: new audio00042,
				icon00043: new audio00043,
				icon00044: new audio00044,
				icon00045: new audio00045,
				icon00046: new audio00046,
				icon00047: new audio00047,
				icon00048: new audio00048,
				icon00049: new audio00049,
				icon_x:    new audio_x
			};

			var t:Array = soundURL.split(".");
			if (t[0] == "")	return new audio_x as Sound;
			return iconNamesCache[t[0]] as Sound;
		}
				
		public static function getIcon(iconURL:String):Bitmap {
			var imageCache:Object = {
				icon00000: new icon00000,	
				icon00001: new icon00001,
				icon00002: new icon00002,
				icon00003: new icon00003,
				icon00004: new icon00004,
				icon00005: new icon00005,
				icon00006: new icon00006,
				icon00007: new icon00007,
				icon00008: new icon00008,
				icon00009: new icon00009,
				icon00010: new icon00010,
				icon00011: new icon00011,
				icon00012: new icon00012,
				icon00013: new icon00013,
				icon00014: new icon00014,
				icon00015: new icon00015,
				icon00016: new icon00016,
				icon00017: new icon00017,
				icon00018: new icon00018,
				icon00019: new icon00019,
				icon00020: new icon00020,
				icon00021: new icon00021,
				icon00022: new icon00022,
				icon00023: new icon00023,
				icon00024: new icon00024,
				icon00025: new icon00025,
				icon00026: new icon00026,
				icon00027: new icon00027,
				icon00028: new icon00028,
				icon00029: new icon00029,
				icon00030: new icon00030,
				icon00030: new icon00030,
				icon00031: new icon00031,
				icon00032: new icon00032,
				icon00033: new icon00033,
				icon00034: new icon00034,
				icon00035: new icon00035,
				icon00036: new icon00036,
				icon00037: new icon00037,
				icon00038: new icon00038,
				icon00039: new icon00039,
				icon00040: new icon00040,
				icon00041: new icon00041,
				icon00042: new icon00042,
				icon00043: new icon00043,
				icon00044: new icon00044,
				icon00045: new icon00045,
				icon00046: new icon00046,
				icon00047: new icon00047,
				icon00048: new icon00048,
				icon00049: new icon_x,
				icon_x: new icon_x
			};
			var t:Array = iconURL.split(".");
			if (t[0] == "")	t[0] = "icon_x";
			return imageCache[t[0]] as Bitmap;
		}

		// Public wrapper for loading the XML from an external class
		public static function loadXML():Array {
			return myloadXML(TheXML);
		}
		private static function myloadXML(xml:XML):Array {

			var actions_from_xml:Array = new Array();

			for (var i:int = 0; i < xml.child("card").length(); i++) {
				actions_from_xml.push(
					new ActionCard(
					xml.child("card")[i].meta.child("id").text(),
					xml.child("card")[i].name.text(),
					xml.child("card")[i].stats.erate.text(),
					xml.child("card")[i].stats.edur.text(),
					xml.child("card")[i].stats.cooldown.text(),
					new EffectMatrix(
					
						xml.child("card")[i].effects.effects_early.energy_e.text(),
						xml.child("card")[i].effects.effects_early.phys_e.text(),
						xml.child("card")[i].effects.effects_early.cog_e.text(),
						xml.child("card")[i].effects.effects_early.labor_str_e.text(),
						xml.child("card")[i].effects.effects_early.ve.text(),
						xml.child("card")[i].effects.effects_early.ue.text(),
						
						xml.child("card")[i].effects.effects_active.energy_a.text(),
						xml.child("card")[i].effects.effects_active.phys_a.text(),
						xml.child("card")[i].effects.effects_active.cog_a.text(),
						xml.child("card")[i].effects.effects_active.labor_str_a.text(),
						xml.child("card")[i].effects.effects_active.va.text(),
						xml.child("card")[i].effects.effects_active.ua.text(),
						
						xml.child("card")[i].effects.effects_trans.energy_t.text(),
						xml.child("card")[i].effects.effects_trans.phys_t.text(),
						xml.child("card")[i].effects.effects_trans.cog_t.text(),
						xml.child("card")[i].effects.effects_trans.labor_str_t.text(),
						xml.child("card")[i].effects.effects_trans.vt.text(),
						xml.child("card")[i].effects.effects_trans.ut.text(),
						
						xml.child("card")[i].effects.effects_pushing.energy_p.text(),
						xml.child("card")[i].effects.effects_pushing.phys_p.text(),
						xml.child("card")[i].effects.effects_pushing.cog_p.text(),
						xml.child("card")[i].effects.effects_pushing.labor_str_p.text(),
						xml.child("card")[i].effects.effects_pushing.vp.text(),
						xml.child("card")[i].effects.effects_pushing.up.text(),
						
						xml.child("card")[i].effects.effects_third.energy_3.text(),
						xml.child("card")[i].effects.effects_third.phys_3.text(),
						xml.child("card")[i].effects.effects_third.cog_3.text(),
						xml.child("card")[i].effects.effects_third.labor_str_3.text(),
						xml.child("card")[i].effects.effects_third.v3.text(),
						xml.child("card")[i].effects.effects_third.u3.text()),
					xml.child("card")[i].effects.success.text(),
					xml.child("card")[i].strings.desc.text(),
					xml.child("card")[i].strings.pros.text(),
					xml.child("card")[i].strings.cons.text(),
					xml.child("card")[i].strings.invalid_msg.text(),
					xml.child("card")[i].strings.success_msg1.text(),
					xml.child("card")[i].strings.success_msg2.text(),
					xml.child("card")[i].strings.fail_msg1.text(),
					xml.child("card")[i].strings.fail_msg2.text(),
					xml.child("card")[i].assets.icon.text(),
					xml.child("card")[i].assets.audio1.text(),
					xml.child("card")[i].assets.audio2.text(),
					xml.child("card")[i].assets.audio3.text()));
			}
			trace ("Done with XML. Top of stack: " + actions_from_xml[0].actionName);
			return actions_from_xml;
		}
		
		// Assets follow
		[Embed (source="../../../lib/icon00000.png" )]
		public static var icon00000:Class;
		[Embed (source="../../../lib/icon00001.png" )]
		public static var icon00001:Class;
		[Embed (source="../../../lib/icon00002.png" )]
		public static var icon00002:Class;
		[Embed (source="../../../lib/icon00003.png" )]
		public static var icon00003:Class;
		[Embed (source="../../../lib/icon00004.png" )]
		public static var icon00004:Class;
		[Embed (source="../../../lib/icon00005.png" )]
		public static var icon00005:Class;
		[Embed (source="../../../lib/icon00006.png" )]
		public static var icon00006:Class;
		[Embed (source="../../../lib/icon00007.png" )]
		public static var icon00007:Class;
		[Embed (source="../../../lib/icon00008.png" )]
		public static var icon00008:Class;
		[Embed (source="../../../lib/icon00009.png" )]
		public static var icon00009:Class;
		[Embed (source="../../../lib/icon00010.png" )]
		public static var icon00010:Class;
		[Embed (source="../../../lib/icon00011.png" )]
		public static var icon00011:Class;
		[Embed (source="../../../lib/icon00012.png" )]
		public static var icon00012:Class;
		[Embed (source="../../../lib/icon00013.png" )]
		public static var icon00013:Class;
		[Embed (source="../../../lib/icon00014.png" )]
		public static var icon00014:Class;
		[Embed (source="../../../lib/icon00015.png" )]
		public static var icon00015:Class;
		[Embed (source="../../../lib/icon00016.png" )]
		public static var icon00016:Class;
		[Embed (source="../../../lib/icon00017.png" )]
		public static var icon00017:Class;
		[Embed (source="../../../lib/icon00018.png" )]
		public static var icon00018:Class;
		[Embed (source="../../../lib/icon00019.png" )]
		public static var icon00019:Class;
		[Embed (source="../../../lib/icon00020.png" )]
		public static var icon00020:Class;
		[Embed (source="../../../lib/icon00021.png" )]
		public static var icon00021:Class;
		[Embed (source="../../../lib/icon00022.png" )]
		public static var icon00022:Class;
		[Embed (source="../../../lib/icon00023.png" )]
		public static var icon00023:Class;
		[Embed (source="../../../lib/icon00024.png" )]
		public static var icon00024:Class;
		[Embed (source="../../../lib/icon00025.png" )]
		public static var icon00025:Class;
		[Embed (source="../../../lib/icon00026.png" )]
		public static var icon00026:Class;
		[Embed (source="../../../lib/icon00027.png" )]
		public static var icon00027:Class;
		[Embed (source="../../../lib/icon00028.png" )]
		public static var icon00028:Class;
		[Embed (source="../../../lib/icon00029.png" )]
		public static var icon00029:Class;
		[Embed (source="../../../lib/icon00030.png" )]
		public static var icon00030:Class;
		[Embed (source="../../../lib/icon00031.png" )]
		public static var icon00031:Class;
		[Embed (source="../../../lib/icon00032.png" )]
		public static var icon00032:Class;
		[Embed (source="../../../lib/icon00033.png" )]
		public static var icon00033:Class;
		[Embed (source="../../../lib/icon00034.png" )]
		public static var icon00034:Class;
		[Embed (source="../../../lib/icon00035.png" )]
		public static var icon00035:Class;
		[Embed (source="../../../lib/icon00036.png" )]
		public static var icon00036:Class;
		[Embed (source="../../../lib/icon00037.png" )]
		public static var icon00037:Class;
		[Embed (source="../../../lib/icon00038.png" )]
		public static var icon00038:Class;
		[Embed (source="../../../lib/icon00039.png" )]
		public static var icon00039:Class;
		[Embed (source="../../../lib/icon00040.png" )]
		public static var icon00040:Class;
		[Embed (source="../../../lib/icon00041.png" )]
		public static var icon00041:Class;
		[Embed (source="../../../lib/icon00042.png" )]
		public static var icon00042:Class;
		[Embed (source="../../../lib/icon00043.png" )]
		public static var icon00043:Class;
		[Embed (source="../../../lib/icon00044.png" )]
		public static var icon00044:Class;
		[Embed (source="../../../lib/icon00045.png" )]
		public static var icon00045:Class;
		[Embed (source="../../../lib/icon00046.png" )]
		public static var icon00046:Class;
		[Embed (source="../../../lib/icon00047.png" )]
		public static var icon00047:Class;
		[Embed (source="../../../lib/icon00048.png" )]
		public static var icon00048:Class;
		// Default: unknown
		[Embed (source="../../../lib/icon_x.png" )]
		public static var icon_x:Class;

		// Trash can
		[Embed (source="../../../lib/trashcan.png" )]
		public static var icon_trashcan:Class;

		// Lock
		[Embed (source="../../../lib/lock_large.png" )]
		public static var icon_lock_large:Class;
		[Embed (source="../../../lib/lock_active.png" )]
		public static var icon_lock:Class;
		[Embed (source="../../../lib/lock_inactive.png" )]
		public static var icon_lock_inactive:Class;
		[Embed (source="../../../lib/lock_large_selected.png" )]
		public static var icon_lock_large_selected:Class;

		// Baby
		[Embed (source="../../../lib/baby.png" )]
		public static var icon_baby:Class;
		[Embed (source="../../../lib/baby_nocord.png" )]
		public static var icon_baby_nocord:Class;
		
		// Scissors
		[Embed (source="../../../lib/scissors.png" )]
		public static var icon_scissors:Class;
		
		// Arrows
		[Embed (source="../../../lib/arrow_up_red.png" )]
		public static var icon_arrowu_red:Class;
		[Embed (source="../../../lib/arrow_up_green.png" )]
		public static var icon_arrowu_green:Class;
		[Embed (source="../../../lib/arrow_down_red.png" )]
		public static var icon_arrowd_red:Class;
		[Embed (source="../../../lib/arrow_down_green.png" )]
		public static var icon_arrowd_green:Class;
		[Embed (source="../../../lib/arrow_space.png" )]
		public static var icon_arrow_space:Class;

		[Embed (source="../../../lib/round-belly-1.png" )]
		public static var round_belly_1:Class;
		

		// Splash screen and help screen assets
		[Embed (source="../../../lib/splash1.png" )]
		public static var splash1:Class;
		[Embed (source="../../../lib/helpscreen1.png" )]
		public static var helpscreen1:Class;
		[Embed (source="../../../lib/help-text.png" )]
		public static var helptexticon:Class;
		[Embed (source="../../../lib/play-text.png" )]
		public static var playtexticon:Class;
		[Embed (source="../../../lib/back-text.png" )]
		public static var backtexticon:Class;
		[Embed (source="../../../lib/lady1_bg.png" )]
		public static var icon_lady1:Class;
		[Embed (source="../../../lib/lady2_bg.png" )]
		public static var icon_lady2:Class;
		[Embed (source="../../../lib/lady3_bg.png" )]
		public static var icon_lady3:Class;
		[Embed (source="../../../lib/lady4_bg.png" )]
		public static var icon_lady4:Class;
		

		// Doctor
		[Embed (source="../../../lib/cartoon-doctor.png" )]
		public static var icon_doctor:Class;
		// Home
		[Embed (source="../../../lib/cartoon-home.png" )]
		public static var icon_home:Class;
		
		// For the tub and shower
		[Embed (source="../../../lib/waves.png" )]
		public static var background_waves:Class;
		
		
		// Sounds
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00000.mp3" )]
		public static var audio00000:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00001.mp3" )]
		public static var audio00001:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00002.mp3" )]
		public static var audio00002:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00002-s.mp3" )]
		public static var audio00002_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00002-f.mp3" )]
		public static var audio00002_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00003.mp3" )]
		public static var audio00003:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00003-s.mp3" )]
		public static var audio00003_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00003-f.mp3" )]
		public static var audio00003_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00004.mp3" )]
		public static var audio00004:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00004-s.mp3" )]
		public static var audio00004_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00004-f.mp3" )]
		public static var audio00004_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00005.mp3" )]
		public static var audio00005:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00005-s.mp3" )]
		public static var audio00005_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00005-f.mp3" )]
		public static var audio00005_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00006.mp3" )]
		public static var audio00006:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00006-s.mp3" )]
		public static var audio00006_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00006-f.mp3" )]
		public static var audio00006_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00007.mp3" )]
		public static var audio00007:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00007-s.mp3" )]
		public static var audio00007_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00008.mp3" )]
		public static var audio00008:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00009.mp3" )]
		public static var audio00009:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00009-s.mp3" )]
		public static var audio00009_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00009-f.mp3" )]
		public static var audio00009_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00010.mp3" )]
		public static var audio00010:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00011.mp3" )]
		public static var audio00011:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00011-s.mp3" )]
		public static var audio00011_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00014.mp3" )]
		public static var audio00014:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00015.mp3" )]
		public static var audio00015:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00016.mp3" )]
		public static var audio00016:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00017.mp3" )]
		public static var audio00017:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00018.mp3" )]
		public static var audio00018:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00018-s.mp3" )]
		public static var audio00018_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00018-f.mp3" )]
		public static var audio00018_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00019.mp3" )]
		public static var audio00019:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00019-s.mp3" )]
		public static var audio00019_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00020.mp3" )]
		public static var audio00020:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00020-s.mp3" )]
		public static var audio00020_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00020-f.mp3" )]
		public static var audio00020_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00022.mp3" )]
		public static var audio00022:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00021.mp3" )]
		public static var audio00021:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00022-s.mp3" )]
		public static var audio00022_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00022-f.mp3" )]
		public static var audio00022_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00023.mp3" )]
		public static var audio00023:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00024.mp3" )]
		public static var audio00024:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00025.mp3" )]
		public static var audio00025:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00026.mp3" )]
		public static var audio00026:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00027.mp3" )]
		public static var audio00027:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00028.mp3" )]
		public static var audio00028:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00029.mp3" )]
		public static var audio00029:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00029-f.mp3" )]
		public static var audio00029_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00030.mp3" )]
		public static var audio00030:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00031.mp3" )]
		public static var audio00031:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00032.mp3" )]
		public static var audio00032:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00033.mp3" )]
		public static var audio00033:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00033-f.mp3" )]
		public static var audio00033_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00034.mp3" )]
		public static var audio00034:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00034-s.mp3" )]
		public static var audio00034_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00034-f.mp3" )]
		public static var audio00034_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00035.mp3" )]
		public static var audio00035:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00035-f.mp3" )]
		public static var audio00035_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00035-s.mp3" )]
		public static var audio00035_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00036.mp3" )]
		public static var audio00036:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00036-s.mp3" )]
		public static var audio00036_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00037.mp3" )]
		public static var audio00037:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00037-f.mp3" )]
		public static var audio00037_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00037-s.mp3" )]
		public static var audio00037_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00038.mp3" )]
		public static var audio00038:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00038-f.mp3" )]
		public static var audio00038_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00038-s.mp3" )]
		public static var audio00038_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00039.mp3" )]
		public static var audio00039:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00039-f.mp3" )]
		public static var audio00039_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00040.mp3" )]
		public static var audio00040:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00041.mp3" )]
		public static var audio00041:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00042.mp3" )]
		public static var audio00042:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00043.mp3" )]
		public static var audio00043:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00044.mp3" )]
		public static var audio00044:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00044-f.mp3" )]
		public static var audio00044_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00045.mp3" )]
		public static var audio00045:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00045-s.mp3" )]
		public static var audio00045_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00046.mp3" )]
		public static var audio00046:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00046-s.mp3" )]
		public static var audio00046_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00047.mp3" )]
		public static var audio00047:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00047-f.mp3" )]
		public static var audio00047_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00047-s.mp3" )]
		public static var audio00047_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00048.mp3" )]
		public static var audio00048:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00048-f.mp3" )]
		public static var audio00048_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00048-s.mp3" )]
		public static var audio00048_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00049.mp3" )]
		public static var audio00049:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00049-f.mp3" )]
		public static var audio00049_f:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/icon00049-s.mp3" )]
		public static var audio00049_s:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Icon Names/ooo.mp3" )]
		public static var audio_x:Class;

		
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/ef-yuck-1.mp3" )]
		public static var audio_eating_failure1:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/ef-yuck-2.mp3" )]
		public static var audio_eating_failure2:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/ef-yuck-3.mp3" )]
		public static var audio_eating_failure3:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/ef-yuck-4.mp3" )]
		public static var audio_eating_failure4:Class;
		
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/es-nom-1.mp3" )]
		public static var audio_eating_success1:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/es-nom-2.mp3" )]
		public static var audio_eating_success2:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/es-nom-3.mp3" )]
		public static var audio_eating_success3:Class;
		
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-distracting-1.mp3" )]
		public static var audio_general_failure1:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-distracting-2.mp3" )]
		public static var audio_general_failure2:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-distracting-3.mp3" )]
		public static var audio_general_failure3:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-dont-like-1.mp3" )]
		public static var audio_general_failure4:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-dont-like-2.mp3" )]
		public static var audio_general_failure5:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-dont-like-3.mp3" )]
		public static var audio_general_failure6:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-dont-want-1.mp3" )]
		public static var audio_general_failure7:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-dont-want-2.mp3" )]
		public static var audio_general_failure8:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-dont-want-3.mp3" )]
		public static var audio_general_failure9:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-go-away-1.mp3" )]
		public static var audio_general_failure10:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-go-away-2.mp3" )]
		public static var audio_general_failure11:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-go-away-3.mp3" )]
		public static var audio_general_failure12:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-go-away-4.mp3" )]
		public static var audio_general_failure13:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-no-1.mp3" )]
		public static var audio_general_failure14:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-no-2.mp3" )]
		public static var audio_general_failure15:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-no-3.mp3" )]
		public static var audio_general_failure16:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-no-4.mp3" )]
		public static var audio_general_failure17:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-nono-1.mp3" )]
		public static var audio_general_failure18:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-nono-2.mp3" )]
		public static var audio_general_failure19:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-nono-3.mp3" )]
		public static var audio_general_failure20:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-nono-4.mp3" )]
		public static var audio_general_failure21:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-not-now-1.mp3" )]
		public static var audio_general_failure22:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-not-now-2.mp3" )]
		public static var audio_general_failure23:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-not-now-3.mp3" )]
		public static var audio_general_failure24:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-dont-need-help.mp3" )]
		public static var audio_general_failure25:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gf-i-cant-do-this.mp3" )]
		public static var audio_general_failure26:Class;

		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gs-fine-1.mp3" )]
		public static var audio_success1:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gs-fine-2.mp3" )]
		public static var audio_success2:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gs-fine-3.mp3" )]
		public static var audio_success3:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gs-ok-1.mp3" )]
		public static var audio_success4:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gs-ok-2.mp3" )]
		public static var audio_success5:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gs-ok-3.mp3" )]
		public static var audio_success6:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gs-yes-1.mp3" )]
		public static var audio_success7:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gs-yes-2.mp3" )]
		public static var audio_success8:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gs-yes-3.mp3" )]
		public static var audio_success9:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gs-yes-4.mp3" )]
		public static var audio_success10:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gs-yes-i-like-that.mp3" )]
		public static var audio_success11:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/gs-mmmm.mp3" )]
		public static var audio_success12:Class;

		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/tf-dont-touch-1.mp3" )]
		public static var audio_touch_fail1:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/tf-dont-touch-2.mp3" )]
		public static var audio_touch_fail2:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/tf-dont-touch-3.mp3" )]
		public static var audio_touch_fail3:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/ts-feels-great-1.mp3" )]
		public static var audio_touch_success1:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/ts-feels-great-2.mp3" )]
		public static var audio_touch_success2:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/ts-feels-great-3.mp3" )]
		public static var audio_touch_success3:Class;

		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/ff-cant-focus-1.mp3" )]
		public static var audio_focus_fail1:Class;
		[Embed (source="../../../lib/Prepared Partner Audio/Success and failure/ff-cant-focus-2.mp3" )]
		public static var audio_focus_fail2:Class;
/*************************************************
 * 
 * RAW XML FOLLOWS
 * 
 * 
 *************************************************/
		public static var TheXML:XML = 
<actions>
	<card>
		<meta>
			<id>1</id>
		</meta>
		<name>Massage shoulders</name>
		<stats>
			<erate>MED</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<energy_e>0</energy_e>
				<phys_e>UU</phys_e>
				<cog_e>U</cog_e>
				<labor_str_e>0</labor_str_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<phys_a>U</phys_a>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>D</cog_t>
				<vt>1</vt>
				<ut>0</ut>
			</effects_transition>
			<effects_pushing>
				<phys_p>U</phys_p>
				<cog_p>U</cog_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>1</v3>
			</effects_third>
			<success>0.87</success>
		</effects>
		<strings>
			<desc>Massage her shoulders gently.</desc>
			<pros>Massage can provide pain relief and psychological support</pros>
			<cons>When more concentration is required, touch can be a distraction.</cons>
			<success_msg1>The shoulder massage feels good.</success_msg1>
			<fail_msg1>The massage fails to provide relief.</fail_msg1>
			<fail_msg2>Don't touch me!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00000.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>2</id>
		</meta>
		<name>Touch shoulders</name>
		<stats>
			<erate>IMM</erate>
			<edur>LONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<energy_e>0</energy_e>
				<phys_e>0</phys_e>
				<cog_e>U</cog_e>
				<labor_str_e>0</labor_str_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>U</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>1</v3>
			</effects_third>
			<success>0.87</success>
		</effects>
		<strings>
			<desc>Place firm hands on her shoulders.</desc>
			<pros>Touch can relieve anxiety.</pros>
			<cons>When more concentration is required, touch can be a distraction.</cons>
			<success_msg1>Your touch is reassuring.</success_msg1>
			<fail_msg1>Your touch fails to provide encouragement.</fail_msg1>
			<fail_msg2>Don't touch me!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00001.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>3</id>
		</meta>
		<name>Massage hand or foot</name>
		<stats>
			<erate>MED</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>U</phys_e>
				<cog_e>UU</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<phys_a>U</phys_a>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>D</cog_t>
				<vt>1</vt>
				<ut>0</ut>
			</effects_transition>
			<effects_pushing>
				<phys_p>U</phys_p>
				<cog_p>U</cog_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>1</v3>
			</effects_third>
			<success>0.87</success>
		</effects>
		<strings>
			<desc>Massage her hand or foot, encouraging her to relax.</desc>
			<pros>Massage can provide pain relief and psychological support</pros>
			<cons>When more concentration is required, touch can be a distraction.</cons>
			<success_msg1>The massage feels good.</success_msg1>
			<fail_msg1>The massage fails to provide relief.</fail_msg1>
			<fail_msg2>Don't touch me!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00014.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>4</id>
		</meta>
		<name>Touch hand or foot</name>
		<stats>
			<erate>IMM</erate>
			<edur>LONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>U</phys_e>
				<cog_e>U</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>U</cog_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>1</v3>
			</effects_third>
			<success>0.87</success>
		</effects>
		<strings>
			<desc>Place firm hands on her hand or foot.</desc>
			<pros>Touch can relieve anxiety.</pros>
			<cons>When more concentration is required, touch can be a distraction.</cons>
			<success_msg1>Your touch is reassuring.</success_msg1>
			<fail_msg1>Your touch fails to provide encouragement.</fail_msg1>
			<fail_msg2>Don't touch me!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00015.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>5</id>
		</meta>
		<name>Play music</name>
		<stats>
			<erate>MED</erate>
			<edur>SHORT</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>U</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>D</cog_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>1</v3>
			</effects_third>
			<success>0.6</success>
		</effects>
		<strings>
			<desc>Play a CD of favorite songs or relaxing melodies, or turn on the radio.</desc>
			<pros>Can increase pain tolerance, reinforce or elevate moods; or cue the woman to move or breathe rhythmically</pros>
			<cons>There are no known drawbacks to using music or sound during labor.</cons>
			<success_msg1>The music is soothing.</success_msg1>
			<fail_msg1>The music is distracting.</fail_msg1>
			<fail_msg2>That's not helping.</fail_msg2>
			<refs>http://www.medscape.com/viewarticle/494120_15</refs>
		</strings>
		<assets>
			<icon>icon00002.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>6</id>
		</meta>
		<name>Sing</name>
		<stats>
			<erate>MED</erate>
			<edur>SHORT</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>U</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>D</cog_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>1</v3>
			</effects_third>
			<success>0.87</success>
		</effects>
		<strings>
			<desc>Sing along to some favorite music, or just sing.</desc>
			<pros>Music can be soothing, encouraging, and comforting.</pros>
			<cons>There are no known drawbacks to singing during labor.</cons>
			<success_msg1>Singing feels great.</success_msg1>
			<fail_msg1>It is harder to cope while singing.</fail_msg1>
			<fail_msg2>I can't sing right now!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00003.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>7</id>
		</meta>
		<name>Try to sleep</name>
		<stats>
			<erate>SLOW</erate>
			<edur>VLONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<energy_e>UUU</energy_e>
				<phys_e>UUU</phys_e>
				<cog_e>UUU</cog_e>
				<labor_str_e>0</labor_str_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<energy_a>UU</energy_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<energy_t>UU</energy_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<energy_p>U</energy_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.9</success>
		</effects>
		<strings>
			<desc>Be energy-efficient! Encourage her to try to sleep between contractions.</desc>
			<pros>Conserve energy in early labor, and if an epidural is in place.</pros>
			<cons>There are no known drawbacks to trying to sleep during labor.</cons>
			<success_msg1>Zzzzzz.</success_msg1>
			<fail_msg1>It is hard to fall asleep.</fail_msg1>
			<fail_msg2>I can't sleep.</fail_msg2>
		</strings>
		<assets>
			<icon>icon00004.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>8</id>
		</meta>
		<name>Request epidural or spinal block</name>
		<stats>
			<erate>VFAST</erate>
			<edur>INF</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>UUU</phys_e>
				<cog_e>D</cog_e>
				<labor_str_e>DD</labor_str_e>
				<ve>1</ve>
				<ue>0</ue>
			</effects_early>
			<effects_active>
				<phys_a>UUU</phys_a>
				<cog_a>U</cog_a>
				<labor_str_a>D</labor_str_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<energy_t>U</energy_t>
				<phys_t>UU</phys_t>
				<cog_t>UU</cog_t>
				<labor_str_t>DD</labor_str_t>
				<vt>1</vt>
				<ut>0</ut>
			</effects_transition>
			<effects_pushing>
				<energy_p>0</energy_p>
				<phys_p>DD</phys_p>
				<cog_p>U</cog_p>
				<labor_str_p>DD</labor_str_p>
				<vp>0</vp>
				<up>0</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.626262626262626</success>
		</effects>
		<strings>
			<desc>An anaesthesiologist places a catheter into the spinal column to deliver pain-relieving drugs.</desc>
			<pros>Great for an exhausted mom to get some rest</pros>
			<cons>With an epidural, the woman is confined to the bed; Can cause labor to slow if used too early; Some women are unable to feel pushing urge</cons>
			<success_msg1>All pain is relieved.</success_msg1>
			<fail_msg1>The epidural fails to provide relief.</fail_msg1>
			<fail_msg2>It's not helping!</fail_msg2>
			<refs>http://linkinghub.elsevier.com/retrieve/pii/S014067369592602X</refs>
		</strings>
		<assets>
			<icon>icon00005.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>10</id>
		</meta>
		<name>Dim lights</name>
		<stats>
			<erate>SLOW</erate>
			<edur>INF</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>U</cog_e>
				<ve>1</ve>
				<ue>0</ue>
			</effects_early>
			<effects_active>
				<cog_a>UU</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>UU</cog_t>
				<labor_str_t>0</labor_str_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>UU</cog_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>1</success>
		</effects>
		<strings>
			<desc>Turn down the lights.</desc>
			<pros>Makes the environment more pleasant; increases ability to concentrate.</pros>
			<success_msg1>The lights are dimmed.</success_msg1>
			<success_msg2>Ah, that's better.</success_msg2>
			<fail_msg1>The darkness is unpleasant.</fail_msg1>
			<fail_msg2>I'm afraid of the dark.</fail_msg2>
		</strings>
		<assets>
			<icon>icon00007.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>11</id>
		</meta>
		<name>Stroking</name>
		<stats>
			<erate>IMM</erate>
			<edur>LONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>U</phys_e>
				<cog_e>U</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<phys_a>U</phys_a>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<labor_str_t>0</labor_str_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>U</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>Stroke her back and arms in rhythm with her breathing.</desc>
			<pros>Helps her focus her breathing, and lets her know you're there</pros>
			<cons>When more concentration is required, touch can be a distraction.</cons>
			<success_msg1>Your touch is reassuring.</success_msg1>
			<fail_msg1>Your touch fails to provide encouragement.</fail_msg1>
			<fail_msg2>Don't touch me!</fail_msg2>
		</strings>
		<assets>
			<icon>icon00008.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>12</id>
		</meta>
		<name>Perineal heat compress</name>
		<stats>
			<erate>MED</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>D</phys_e>
				<ve>1</ve>
				<ue>0</ue>
			</effects_early>
			<effects_active>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<phys_t>U</phys_t>
				<cog_t>U</cog_t>
				<labor_str_t>U</labor_str_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>U</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>Apply warm, wet towels to the perineum.</desc>
			<pros>Useful during pushing to increase circulation and avoid tearing</pros>
			<cons>Do not use if she has an epidural in place</cons>
			<success_msg1>Heat on the perineum is wonderful.</success_msg1>
			<success_msg2>That feels great.</success_msg2>
			<fail_msg1>The heat pack is distracting right now.</fail_msg1>
			<fail_msg2>Don't touch me!</fail_msg2>
			<refs>http://birthing-options.suite101.com/article.cfm/heat_packs_for_labor_pain</refs>
		</strings>
		<assets>
			<icon>icon00009.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>13</id>
		</meta>
		<name>Acupressure</name>
		<stats>
			<erate>MED</erate>
			<edur>LONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>U</phys_e>
				<labor_str_e>U</labor_str_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<phys_a>U</phys_a>
				<cog_a>U</cog_a>
				<labor_str_a>U</labor_str_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<phys_t>U</phys_t>
				<cog_t>U</cog_t>
				<labor_str_t>U</labor_str_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<phys_p>U</phys_p>
				<cog_p>U</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>With a little research, you can find acupressure points and gently massage them.</desc>
			<pros>Has been shown to decrease pain.</pros>
			<cons>Needs some background research and/or practice</cons>
			<success_msg1>The acupressure relieves some pain.</success_msg1>
			<fail_msg1>The acupressure fails to provide relief.</fail_msg1>
			<fail_msg2>Don't touch me!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00010.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>14</id>
		</meta>
		<name>Chant, mantra, song, or prayer</name>
		<stats>
			<erate>SLOW</erate>
			<edur>LONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>U</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>Vocalize: make some noise</desc>
			<pros>Mental activity can distract from labor pain.</pros>
			<success_msg1>The mental focus helps cope with the contractions.</success_msg1>
			<fail_msg1>Vocalization is not coming easily.</fail_msg1>
			<fail_msg2>I feel silly making all these noises.</fail_msg2>
		</strings>
		<assets>
			<icon>icon00011.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>15</id>
		</meta>
		<name>Focus on music or voice</name>
		<stats>
			<erate>SLOW</erate>
			<edur>LONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>U</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>Focus on music or voice</desc>
			<pros>Mental activity can distract from labor pain.</pros>
			<success_msg1>The mental focus helps cope with the contractions.</success_msg1>
			<fail_msg1>It is hard to focus on noises. They are so distracting.</fail_msg1>
			<fail_msg2>Turn that music off!</fail_msg2>
		</strings>
		<assets>
			<icon>icon00033.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>16</id>
		</meta>
		<name>Use birth ball</name>
		<stats>
			<erate>IMM</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<energy_e>D</energy_e>
				<phys_e>U</phys_e>
				<labor_str_e>U</labor_str_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<energy_a>D</energy_a>
				<phys_a>U</phys_a>
				<labor_str_a>U</labor_str_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<energy_t>D</energy_t>
				<phys_t>U</phys_t>
				<cog_t>D</cog_t>
				<labor_str_t>U</labor_str_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<labor_str_p>U</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>Sit on the ball; lean over the ball; put the ball on the bed and lean on it</desc>
			<pros>Changing position can help move the baby.</pros>
			<success_msg1>The birth ball helps.</success_msg1>
			<fail_msg1>That position is uncomfortable.</fail_msg1>
			<fail_msg2>I can't!</fail_msg2>
		</strings>
		<assets>
			<icon>icon00016.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>17</id>
		</meta>
		<name>Still touch</name>
		<stats>
			<erate>IMM</erate>
			<edur>VLONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>U</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<labor_str_t>0</labor_str_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.87</success>
		</effects>
		<strings>
			<desc>Place your palms on her shoulders, lower back, or hands.</desc>
			<pros>It helps her know you're there.</pros>
			<cons>When more concentration is required, touch can be a distraction.</cons>
			<success_msg1>Your touch is reassuring.</success_msg1>
			<fail_msg1>Your touch fails to provide encouragement.</fail_msg1>
			<fail_msg2>Don't touch me!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00017.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>18</id>
		</meta>
		<name>Play a card game</name>
		<stats>
			<erate>SLOW</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>U</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<cog_a>DD</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>DD</cog_t>
				<vt>1</vt>
				<ut>0</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>DD</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>0</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>1</success>
		</effects>
		<strings>
			<desc>Poker, Spades, or even War!</desc>
			<pros>A card game is a good distraction in early labor, when things may not be progressing fast.</pros>
			<cons>In active labor and beyond, do not try to distract her.</cons>
			<success_msg1>The card game is fun and distracting.</success_msg1>
			<success_msg2>Ha ha, I win!</success_msg2>
			<fail_msg1>Distraction is not appropriate at this point.</fail_msg1>
			<fail_msg2>A card game right now? No way!</fail_msg2>
		</strings>
		<assets>
			<icon>icon00018.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>19</id>
		</meta>
		<name>Hold hand</name>
		<stats>
			<erate>IMM</erate>
			<edur>LONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>U</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>U</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.87</success>
		</effects>
		<strings>
			<desc>Hold her hand.</desc>
			<pros>It helps her know you're there.</pros>
			<success_msg1>Your touch is reassuring.</success_msg1>
			<fail_msg1>Your touch fails to provide encouragement.</fail_msg1>
			<fail_msg2>Don't touch me!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00019.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>20</id>
		</meta>
		<name>Request narcotic</name>
		<stats>
			<erate>IMM</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>UUU</phys_e>
				<cog_e>DD</cog_e>
				<labor_str_e>0</labor_str_e>
				<ve>1</ve>
				<ue>0</ue>
			</effects_early>
			<effects_active>
				<phys_a>UU</phys_a>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<phys_t>UU</phys_t>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<phys_p>U</phys_p>
				<cog_p>U</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>Narcotics used are about 100 times stronger than morphine; injected into the IV.</desc>
			<pros>In active labor and beyond, narcotics are reported to "take the edge off."</pros>
			<cons>Labor is confined to the bed; each subsequent dose works less well; when it wears off, contractions are stronger</cons>
			<success_msg1>The drugs take the edge off the contractions.</success_msg1>
			<fail_msg1>The drugs do not provide adequate relief.</fail_msg1>
			<fail_msg2>The drugs didn't do anything for my pain.</fail_msg2>
		</strings>
		<assets>
			<icon>icon00020.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>21</id>
		</meta>
		<name>Eat a popsicle</name>
		<stats>
			<erate>SLOW</erate>
			<edur>SHORT</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<energy_e>U</energy_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<energy_a>U</energy_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<energy_t>U</energy_t>
				<phys_t>U</phys_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<energy_p>U</energy_p>
				<phys_p>U</phys_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>When hospital policy does not allow eating solids, a popsicle is a good source of energy.</desc>
			<pros>Gives her an energy boost (and sugar rush).</pros>
			<success_msg1>I feel more energized.</success_msg1>
			<fail_msg1>The popsicle fails to satisfy hunger.</fail_msg1>
			<fail_msg2>I'm still hungry.</fail_msg2>
		</strings>
		<assets>
			<icon>icon00021.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>22</id>
		</meta>
		<name>Chew ice chips</name>
		<stats>
			<erate>IMM</erate>
			<edur>SHORT</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<energy_e>U</energy_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<energy_a>U</energy_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<energy_t>U</energy_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<energy_p>U</energy_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>When hospital policy does not allow eating or drinking, offer ice chips.</desc>
			<pros>Relieves a dry, thirsty mouth</pros>
			<success_msg1>I feel less thirsty.</success_msg1>
			<fail_msg1>Ice chips fail to satisfy thirst.</fail_msg1>
			<fail_msg2>I'm still thirsty.</fail_msg2>
		</strings>
		<assets>
			<icon>icon00023.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>23</id>
		</meta>
		<name>Eat a sandwich</name>
		<stats>
			<erate>SLOW</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<energy_e>UU</energy_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<energy_a>UU</energy_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<energy_t>UU</energy_t>
				<phys_t>U</phys_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<energy_p>UU</energy_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>When hungry, she should eat. It gives her energy.</desc>
			<pros>Energy boost.</pros>
			<success_msg1>I feel more energized.</success_msg1>
			<fail_msg1>The sandwich fails to satisfy hunger.</fail_msg1>
			<fail_msg2>I'm still hungry.</fail_msg2>
		</strings>
		<assets>
			<icon>icon00024.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>24</id>
		</meta>
		<name>Sip water</name>
		<stats>
			<erate>IMM</erate>
			<edur>SHORT</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<energy_e>U</energy_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<energy_a>U</energy_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<energy_t>U</energy_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<energy_p>U</energy_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>When thirsty, she should drink.</desc>
			<pros>Relieves thirst.</pros>
			<success_msg1>I feel less thirsty.</success_msg1>
			<fail_msg1>The water does not satisfy thirst.</fail_msg1>
			<fail_msg2>I'm still thirsty.</fail_msg2>
		</strings>
		<assets>
			<icon>icon00025.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>25</id>
		</meta>
		<name>Visual focus</name>
		<stats>
			<erate>SLOW</erate>
			<edur>LONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>U</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>U</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>Focus on a photograph, pattern, or other visual element.</desc>
			<pros>Mental activity can distract from labor pain.</pros>
			<success_msg1>The mental focus helps cope with the contractions.</success_msg1>
			<fail_msg1>Focusing right now is impossible.</fail_msg1>
			<fail_msg2>I can't focus.</fail_msg2>
		</strings>
		<assets>
			<icon>icon00026.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>26</id>
		</meta>
		<name>Perineal massage</name>
		<stats>
			<erate>MED</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>D</phys_e>
				<ve>1</ve>
				<ue>0</ue>
			</effects_early>
			<effects_active>
				<cog_a>D</cog_a>
				<va>1</va>
				<ua>0</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>0</ut>
			</effects_transition>
			<effects_pushing>
				<energy_p>0</energy_p>
				<phys_p>U</phys_p>
				<cog_p>U</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.87</success>
		</effects>
		<strings>
			<desc>You (or a nurse) can massage her perineum with thumb and forefinger.</desc>
			<pros>Help her focus her pushing efforts and help prevent tearing.</pros>
			<cons>When more concentration is required, touch can be a distraction.</cons>
			<success_msg1>The massage helps to focus pushing efforts.</success_msg1>
			<fail_msg1>The massage distracts from pushing.</fail_msg1>
			<fail_msg2>Don't touch me!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00027.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>27</id>
		</meta>
		<name>Rhythmic breathing</name>
		<stats>
			<erate>SLOW</erate>
			<edur>LONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>U</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>U</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.69</success>
		</effects>
		<strings>
			<desc>Breathe in time with the contractions, music, or ticking clock.</desc>
			<pros>Mental activity can distract from labor pain.</pros>
			<success_msg1>Breathing in rhythm helps stay on top of the contractions.</success_msg1>
			<fail_msg1>Rhythmic breathing fails to provide relief.</fail_msg1>
			<fail_msg2>It's not helping!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00028.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>28</id>
		</meta>
		<name>Help with breathing</name>
		<stats>
			<erate>FAST</erate>
			<edur>LONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>D</cog_e>
				<ve>1</ve>
				<ue>0</ue>
			</effects_early>
			<effects_active>
				<cog_a>UU</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>U</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.69</success>
		</effects>
		<strings>
			<desc>Show her how to breathe, slowly and deeply, by breathing with her.</desc>
			<pros>Can help her to regain control.</pros>
			<success_msg1>Breathing together helps to stay on top of the contractions.</success_msg1>
			<fail_msg1>Help with breathing fails to provide relief.</fail_msg1>
			<fail_msg2>It's not helping!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00029.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>29</id>
		</meta>
		<name>Take a shower</name>
		<stats>
			<erate>MED</erate>
			<edur>LONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>U</phys_e>
				<cog_e>U</cog_e>
				<labor_str_e>U</labor_str_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<phys_a>U</phys_a>
				<cog_a>U</cog_a>
				<labor_str_a>U</labor_str_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<phys_t>U</phys_t>
				<cog_t>U</cog_t>
				<labor_str_t>U</labor_str_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<labor_str_p>0</labor_str_p>
				<vp>0</vp>
				<up>0</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.81</success>
		</effects>
		<strings>
			<desc>Take a shower.</desc>
			<pros>Relief, relaxation, pain relief, and control. Water on the back can help ease back labor.</pros>
			<success_msg1>The shower is a welcome relief.</success_msg1>
			<fail_msg1>The shower fails to provide relief.</fail_msg1>
			<fail_msg2>The shower is an awful place for me!</fail_msg2>
		</strings>
		<assets>
			<icon>icon00030.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>30</id>
		</meta>
		<name>Take a bath</name>
		<stats>
			<erate>MED</erate>
			<edur>VLONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>U</phys_e>
				<cog_e>U</cog_e>
				<labor_str_e>DD</labor_str_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<phys_a>UU</phys_a>
				<cog_a>U</cog_a>
				<labor_str_a>U</labor_str_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<phys_t>UU</phys_t>
				<cog_t>U</cog_t>
				<labor_str_t>U</labor_str_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<labor_str_p>0</labor_str_p>
				<vp>0</vp>
				<up>0</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.81</success>
		</effects>
		<strings>
			<desc>Immerse in a bath tub filled with warm (not hot) water.</desc>
			<pros>Relief, relaxation, pain relief, and control</pros>
			<cons>Labor progress can be slowed if entering before active labor.</cons>
			<success_msg1>The warm bath water takes the edge off the contractions.</success_msg1>
			<fail_msg1>The bath fails to provide relief.</fail_msg1>
			<fail_msg2>The bath feels terrible!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00031.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>31</id>
		</meta>
		<name>Get in large tub</name>
		<stats>
			<erate>MED</erate>
			<edur>VLONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>U</phys_e>
				<cog_e>U</cog_e>
				<labor_str_e>DD</labor_str_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<phys_a>UU</phys_a>
				<cog_a>U</cog_a>
				<labor_str_a>U</labor_str_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<phys_t>UU</phys_t>
				<cog_t>U</cog_t>
				<labor_str_t>U</labor_str_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<phys_p>UU</phys_p>
				<cog_p>U</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>0</vp>
				<up>0</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.81</success>
		</effects>
		<strings>
			<desc>Immerse in a bath tub filled with warm (not hot) water.</desc>
			<pros>Relief, relaxation, pain relief, and control</pros>
			<cons>Labor progress can be slowed if entering before active labor.</cons>
			<success_msg1>The warm bath water takes the edge off the contractions.</success_msg1>
			<fail_msg1>The large tub fails to provide relief.</fail_msg1>
			<fail_msg2>The large tub feels awful!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00032.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>32</id>
		</meta>
		<name>Change position</name>
		<stats>
			<erate>IMM</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<energy_e>D</energy_e>
				<phys_e>U</phys_e>
				<cog_e>U</cog_e>
				<labor_str_e>U</labor_str_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<energy_a>D</energy_a>
				<phys_a>U</phys_a>
				<cog_a>U</cog_a>
				<labor_str_a>U</labor_str_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<energy_t>D</energy_t>
				<cog_t>U</cog_t>
				<labor_str_t>UU</labor_str_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<energy_p>D</energy_p>
				<phys_p>U</phys_p>
				<labor_str_p>U</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.99</success>
		</effects>
		<strings>
			<desc>Get up and move.</desc>
			<pros>Upright positions can decrease pain and shorten labor; changing position can help move the baby</pros>
			<success_msg1>Changing position helps a lot.</success_msg1>
			<fail_msg1>Changing position fails to provide relief.</fail_msg1>
			<fail_msg2>I don't want to!</fail_msg2>
		</strings>
		<assets>
			<icon>icon00034.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>33</id>
		</meta>
		<name>Smooch</name>
		<stats>
			<erate>FAST</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>U</phys_e>
				<cog_e>U</cog_e>
				<labor_str_e>U</labor_str_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<phys_a>U</phys_a>
				<cog_a>U</cog_a>
				<labor_str_a>U</labor_str_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<phys_t>U</phys_t>
				<cog_t>U</cog_t>
				<labor_str_t>U</labor_str_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<phys_p>U</phys_p>
				<labor_str_p>U</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.87</success>
		</effects>
		<strings>
			<desc>Yes, kissing.</desc>
			<pros>Smooching has been shown to release endorphins and oxytocin</pros>
			<success_msg1>The contractions come in a quick flurry, but the baby moves down so much faster.</success_msg1>
			<fail_msg1>Kissing fails to provide any relief.</fail_msg1>
			<fail_msg2>I don't want to!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00035.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>34</id>
		</meta>
		<name>Offer compliments</name>
		<stats>
			<erate>FAST</erate>
			<edur>SHORT</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>U</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>U</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.6</success>
		</effects>
		<strings>
			<desc>"You look powerful."</desc>
			<pros>Mental activity can distract from labor pain.</pros>
			<success_msg1>The compliments are encouraging.</success_msg1>
			<success_msg2>Thank you.</success_msg2>
			<fail_msg1>Your compliments fail to provide relief.</fail_msg1>
			<fail_msg2>Yeah, right.</fail_msg2>
		</strings>
		<assets>
			<icon>icon00036.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>35</id>
		</meta>
		<name>Offer encouragement</name>
		<stats>
			<erate>FAST</erate>
			<edur>SHORT</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>U</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>U</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.6</success>
		</effects>
		<strings>
			<desc>"It's almost over; you're doing great."</desc>
			<pros>Mental activity can distract from labor pain.</pros>
			<success_msg1>The encouragement helps.</success_msg1>
			<success_msg2>Thank you.</success_msg2>
			<fail_msg1>Your encouragement fails to provide relief.</fail_msg1>
			<fail_msg2>Don't be patronizing.</fail_msg2>
		</strings>
		<assets>
			<icon>icon00037.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>36</id>
		</meta>
		<name>Affirmation</name>
		<stats>
			<erate>FAST</erate>
			<edur>SHORT</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>U</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>U</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.6</success>
		</effects>
		<strings>
			<desc>Be positive. "Repeat after me: I am doing this."</desc>
			<pros>A positive attitude can have tangible results.</pros>
			<success_msg1>Repeating positive things helps maintain a positive attitude.</success_msg1>
			<success_msg2>I can do this.  I am doing this.</success_msg2>
			<fail_msg1>Your affirmation fails to provide relief.</fail_msg1>
			<fail_msg2>No, no, no.</fail_msg2>
		</strings>
		<assets>
			<icon>icon00038.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>37</id>
		</meta>
		<name>Stand and walk</name>
		<stats>
			<erate>IMM</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<energy_e>D</energy_e>
				<labor_str_e>U</labor_str_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<energy_a>D</energy_a>
				<labor_str_a>U</labor_str_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<energy_t>D</energy_t>
				<labor_str_t>U</labor_str_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<energy_p>D</energy_p>
				<phys_p>D</phys_p>
				<labor_str_p>U</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.99</success>
		</effects>
		<strings>
			<desc>Get up and move.</desc>
			<pros>Upright positions can decrease pain and shorten labor; changing positions can help move the baby</pros>
			<success_msg1>Walking helps move the baby.</success_msg1>
			<fail_msg1>Standing and walking fail to provide relief.</fail_msg1>
			<fail_msg2>I can't move, much less walk.</fail_msg2>
		</strings>
		<assets>
			<icon>icon00039.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>38</id>
		</meta>
		<name>Rolling pressure on back</name>
		<stats>
			<erate>IMM</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>U</phys_e>
				<ve>1</ve>
				<ue>0</ue>
			</effects_early>
			<effects_active>
				<phys_a>U</phys_a>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<phys_t>U</phys_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<phys_p>U</phys_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.87</success>
		</effects>
		<strings>
			<desc>A rolling pin can be used as a massage tool to help with back labor.</desc>
			<pros>Massage can provide pain relief and psychological support</pros>
			<cons>When more concentration is required, touch can be a distraction.</cons>
			<success_msg1>The massage provides some relief against back pain.</success_msg1>
			<fail_msg1>The rolling pressure fails to provide relief.</fail_msg1>
			<fail_msg2>Don't touch me!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00040.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>39</id>
		</meta>
		<name>Double hip squeeze</name>
		<stats>
			<erate>IMM</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>U</phys_e>
				<ve>1</ve>
				<ue>0</ue>
			</effects_early>
			<effects_active>
				<phys_a>U</phys_a>
				<cog_a>U</cog_a>
				<labor_str_a>0</labor_str_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<phys_t>UU</phys_t>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<phys_p>U</phys_p>
				<labor_str_p>UU</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>Squeeze her hips together from both sides of her body.</desc>
			<pros>Widens the opening of her pelvis</pros>
			<success_msg1>The double hip squeeze provides some relief.</success_msg1>
			<fail_msg1>The double hip squeeze fails to provide relief.</fail_msg1>
			<fail_msg2>Don't touch me!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00041.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>40</id>
		</meta>
		<name>Relax during and/or between contractions</name>
		<stats>
			<erate>MED</erate>
			<edur>LONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<energy_e>U</energy_e>
				<labor_str_e>U</labor_str_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<energy_a>U</energy_a>
				<labor_str_a>U</labor_str_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<energy_t>U</energy_t>
				<labor_str_t>U</labor_str_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<energy_p>UU</energy_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.69</success>
		</effects>
		<strings>
			<desc>Really try to relax during and/or between contractions.</desc>
			<pros>Relaxation uses less energy; mental activity has been shown to decrease pain</pros>
			<success_msg1>Relaxing the muscles makes them hurt less.</success_msg1>
			<fail_msg1>Relaxation is impossible.</fail_msg1>
			<fail_msg2>I can't relax! It's too intense!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00042.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>41</id>
		</meta>
		<name>Counterpressure to back</name>
		<stats>
			<erate>FAST</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>U</phys_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<phys_a>U</phys_a>
				<cog_a>U</cog_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<phys_t>U</phys_t>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<phys_p>U</phys_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.87</success>
		</effects>
		<strings>
			<desc>Press hard on her lower back.</desc>
			<pros>Can help with back labor</pros>
			<success_msg1>The counterpressure helps against back labor.</success_msg1>
			<fail_msg1>The counterpressure fails to provide relief.</fail_msg1>
			<fail_msg2>Don't touch me!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00043.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>42</id>
		</meta>
		<name>Aromatherapy</name>
		<stats>
			<erate>SLOW</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>U</cog_e>
				<labor_str_e>U</labor_str_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<phys_a>D</phys_a>
				<cog_a>U</cog_a>
				<labor_str_a>U</labor_str_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<labor_str_t>U</labor_str_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<labor_str_p>U</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.5</success>
		</effects>
		<strings>
			<desc>Rose oil, lavender, and frankincense can help relieve anxiety, fear, and pain.</desc>
			<pros>Some women find aromatherapy helpful.</pros>
			<cons>Some women are sensitive to smells in labor.</cons>
			<success_msg1>The scents provide some relief against pain and nausea.</success_msg1>
			<fail_msg1>Aromatherapy fails to provide relief.</fail_msg1>
			<fail_msg2>The smell is revolting!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00044.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>43</id>
		</meta>
		<name>Heat pack</name>
		<stats>
			<erate>MED</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>U</phys_e>
				<ve>1</ve>
				<ue>0</ue>
			</effects_early>
			<effects_active>
				<phys_a>U</phys_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<phys_t>U</phys_t>
				<cog_t>U</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<phys_p>U</phys_p>
				<cog_p>U</cog_p>
				<labor_str_p>U</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.49</success>
		</effects>
		<strings>
			<desc>Apply a heat pack to her back, lower abdomen, or groin.</desc>
			<pros>Provides distraction; blocks the transmission of pain to the brain; helps with back labor</pros>
			<cons>Bad if she is already hot, or she has an epidural in place</cons>
			<success_msg1>The heat pack provides some relief.</success_msg1>
			<success_msg2>Mmmm</success_msg2>
			<fail_msg1>The heat pack fails to provide relief.</fail_msg1>
			<fail_msg2>Get that off me!</fail_msg2>
			<refs>http://birthing-options.suite101.com/article.cfm/heat_packs_for_labor_pain</refs>
		</strings>
		<assets>
			<icon>icon00045.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>44</id>
		</meta>
		<name>Cold pack</name>
		<stats>
			<erate>MED</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<phys_e>U</phys_e>
				<ve>1</ve>
				<ue>0</ue>
			</effects_early>
			<effects_active>
				<phys_a>U</phys_a>
				<va>1</va>
				<ua>0</ua>
			</effects_active>
			<effects_transition>
				<phys_t>D</phys_t>
				<labor_str_t>0</labor_str_t>
				<vt>1</vt>
				<ut>0</ut>
			</effects_transition>
			<effects_pushing>
				<phys_p>D</phys_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
			<success>0.49</success>
		</effects>
		<strings>
			<desc>Apply a cold pack to her back, chest, or face; massage between thumb and palm with iced washcloth</desc>
			<pros>Can relieve muscle spasms and inflammation.</pros>
			<cons>If she's cold, she won't like a cold pack.</cons>
			<success_msg1>The cold pack provides some relief.</success_msg1>
			<success_msg2>Mmmm</success_msg2>
			<fail_msg1>The cold pack fails to provide relief.</fail_msg1>
			<fail_msg2>Get that off me!</fail_msg2>
			<refs>simkin04</refs>
		</strings>
		<assets>
			<icon>icon00022.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>45</id>
		</meta>
		<name>Visualization</name>
		<stats>
			<erate>SLOW</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<cog_e>U</cog_e>
				<labor_str_e>U</labor_str_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<cog_a>U</cog_a>
				<labor_str_a>U</labor_str_a>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>U</cog_t>
				<labor_str_t>U</labor_str_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<labor_str_p>U</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>Imagine the details of a pleasant place, or what happens when the baby descends.</desc>
			<pros>Mental activity can distract from labor pain.</pros>
			<success_msg1>The mental focus helps cope with the contractions.</success_msg1>
			<success_msg2>I see myself opening like a soft angora sweater over my baby's head.</success_msg2>
			<fail_msg1>Visualization right now is impossible.</fail_msg1>
			<fail_msg2>I can't focus.</fail_msg2>
		</strings>
		<assets>
			<icon>icon00046.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>46</id>
		</meta>
		<name>Count breaths</name>
		<stats>
			<erate>FAST</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<energy_e>D</energy_e>
				<phys_e>U</phys_e>
				<cog_e>D</cog_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<va>1</va>
				<ua>1</ua>
			</effects_active>
			<effects_transition>
				<cog_t>UUU</cog_t>
				<vt>1</vt>
				<ut>1</ut>
			</effects_transition>
			<effects_pushing>
				<cog_p>U</cog_p>
				<labor_str_p>0</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>0</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>During a contraction, count with her each breath she takes.</desc>
			<pros>Mental activity can distract from labor pain.</pros>
			<success_msg1>The mental focus helps cope with the contractions.</success_msg1>
			<success_msg2>One, two, three…</success_msg2>
			<fail_msg1>Counting the breaths fails to provide relief.</fail_msg1>
			<fail_msg2>Tell me how many breaths are left!</fail_msg2>
		</strings>
		<assets>
			<icon>icon00047.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>47</id>
		</meta>
		<name>Directed pushing</name>
		<stats>
			<erate>IMM</erate>
			<edur>LONG</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<ve>0</ve>
				<ue>0</ue>
			</effects_early>
			<effects_active>
				<va>0</va>
				<ua>0</ua>
			</effects_active>
			<effects_transition>
				<energy_t>0</energy_t>
				<phys_t>0</phys_t>
				<cog_t>0</cog_t>
				<labor_str_t>0</labor_str_t>
				<vt>0</vt>
				<ut>0</ut>
			</effects_transition>
			<effects_pushing>
				<phys_p>D</phys_p>
				<cog_p>U</cog_p>
				<labor_str_p>UUU</labor_str_p>
				<vp>1</vp>
				<up>1</up>
			</effects_pushing>
			<effects_third>
				<labor_str_3>U</labor_str_3>
				<v3>0</v3>
			</effects_third>
		</effects>
		<strings>
			<desc>During a contraction, count to ten as she holds her breath and bears down.</desc>
			<pros>Accelerates the descent of the baby</pros>
			<cons>Most difficult and tiring way to push</cons>
			<success_msg1>The baby moves down more quickly.</success_msg1>
			<fail_msg1>Directed pushing is too intense and painful.</fail_msg1>
			<fail_msg2>Don't tell me what to do!</fail_msg2>
			<refs>http://www.birthingnaturally.net/birthplan/options/push.html</refs>
		</strings>
		<assets>
			<icon>icon00048.png</icon>
		</assets>
	</card>
	<card>
		<meta>
			<id>49</id>
		</meta>
		<name>Lie on back</name>
		<stats>
			<erate>MED</erate>
			<edur>MED</edur>
			<cooldown>MED</cooldown>
		</stats>
		<effects>
			<effects_early>
				<energy_e>UU</energy_e>
				<phys_e>U</phys_e>
				<ve>1</ve>
				<ue>1</ue>
			</effects_early>
			<effects_active>
				<energy_a>U</energy_a>
				<phys_a>D</phys_a>
				<cog_a>D</cog_a>
				<va>1</va>
				<ua>0</ua>
			</effects_active>
			<effects_transition>
				<energy_t>U</energy_t>
				<phys_t>DD</phys_t>
				<cog_t>D</cog_t>
				<vt>1</vt>
				<ut>0</ut>
			</effects_transition>
			<effects_pushing>
				<energy_p>U</energy_p>
				<phys_p>D</phys_p>
				<cog_p>D</cog_p>
				<vp>1</vp>
				<up>0</up>
			</effects_pushing>
			<effects_third>
				<energy_3>U</energy_3>
				<phys_3>U</phys_3>
				<cog_3>U</cog_3>
				<labor_str_3>U</labor_str_3>
				<v3>1</v3>
			</effects_third>
			<success>0.99</success>
		</effects>
		<strings>
			<desc>Get her to lie down on her back in bed.</desc>
			<pros>She can relax.</pros>
			<cons>This position goes against gravity; the baby may have a hard time moving down.</cons>
			<success_msg1>She lies on her back.</success_msg1>
			<fail_msg1>The baby stops moving down as well.</fail_msg1>
			<fail_msg2>This feels awful. I need to get up.</fail_msg2>
		</strings>
		<assets>
			<icon>icon00049.png</icon>
		</assets>
	</card>
</actions>


/*************************************************
 * 
 * END RAW XML
 * 
 * 
 *************************************************/

	}
}
