package birth.trainer {
    public class EffectMatrix {
		private var _earlylabor:Effect  = new Effect();
		private var _activelabor:Effect = new Effect();
		private var _transition:Effect  = new Effect();
		private var _pushing:Effect     = new Effect();
		private var _thirdstage:Effect  = new Effect();
		

		public function EffectMatrix(
				EE:String="", PE:String="", CE:String="", SE:String="", VE:String="", UE:String="",
				EA:String="", PA:String="", CA:String="", SA:String="", VA:String="", UA:String="",
				ET:String="", PT:String="", CT:String="", ST:String="", VT:String="", UT:String="",
				EP:String="", PP:String="", CP:String="", SP:String="", VP:String="", UP:String="",
				E3:String="", P3:String="", C3:String="", S3:String="", V3:String="", U3:String="") {

			setEffects(_earlylabor,  EE, PE, CE, SE, (VE == "")? "1":VE, (UE == "")? "1":UE);
			setEffects(_activelabor, EA, PA, CA, SA, (VA == "")? "1":VA, (UA == "")? "1":UA);
			setEffects(_transition,  ET, PT, CT, ST, (VT == "")? "1":VT, (UT == "")? "1":UT);
			setEffects(_pushing,     EP, PP, CP, SP, (VP == "")? "1":VP, (UP == "")? "1":UP);
			setEffects(_thirdstage,  E3, P3, C3, S3, (V3 == "")? "1":V3, (U3 == "")? "1":U3);
		}
		public function getUsefulBits():Array {
			return new Array(_earlylabor.useful, _activelabor.useful, _transition.useful, _pushing.useful, _thirdstage.useful);
		}
		public function getValidBits():Array {
			return new Array(_earlylabor.valid, _activelabor.valid, _transition.valid, _pushing.valid, _thirdstage.valid);
		}
		public function get earlyLaborEffects():Effect{
			return _earlylabor;
		}
		public function get activeLaborEffects():Effect {
			return _activelabor;
		}
		public function get transitionEffects():Effect {
			return _transition;
			trace(getPrintableEffectMatrix());
		}
		public function get pushingEffects():Effect {
			return _pushing;
		}
		public function get thirdStageEffects():Effect {
			return _thirdstage;
		}
		public function setEffects(e:Effect, energy:String,  physicaleffects:String, cognitiveeffects:String, strLabor:String, valid:String, useful:String):void {
			e.energy    = Constant.stringToEffect(energy);
			e.physical  = Constant.stringToEffect(physicaleffects);
			e.cognitive = Constant.stringToEffect(cognitiveeffects);
			e.strength  = Constant.stringToEffect(strLabor);
			e.valid     = (Constant.stringToEffect(valid)  == 0)? false : true;
			e.useful    = (Constant.stringToEffect(useful) == 0)? false : true;
		}
		public function getPrintableEffectMatrix():String {
			var s:String = new String();
			
			s  = "  | E \tP\tC\tS\tV\tU\n"
//			s += "--------------------------------------------------------\n"
			s += "E | " + Constant.effectToString(_earlylabor.energy)  + "\t" + Constant.effectToString(_earlylabor.physical)  + "\t" + Constant.effectToString(_earlylabor.cognitive)  + "\t" + Constant.effectToString(_earlylabor.strength)  + "\t" + (_earlylabor.valid?  "T" : "")  + "\t" + (_earlylabor.useful?  "T" : "")  + "\n";
			s += "A | " + Constant.effectToString(_activelabor.energy) + "\t" + Constant.effectToString(_activelabor.physical) + "\t" + Constant.effectToString(_activelabor.cognitive) + "\t" + Constant.effectToString(_activelabor.strength) + "\t" + (_activelabor.valid? "T" : "")  + "\t" + (_activelabor.useful? "T" : "")  + "\n";
			s += "T | " + Constant.effectToString(_transition.energy)  + "\t" + Constant.effectToString(_transition.physical)  + "\t" + Constant.effectToString(_transition.cognitive)  + "\t" + Constant.effectToString(_transition.strength)  + "\t" + (_transition.valid?  "T" : "")  + "\t" + (_transition.useful?  "T" : "")  + "\n";
			s += "P | " + Constant.effectToString(_pushing.energy)     + "\t" + Constant.effectToString(_pushing.physical)     + "\t" + Constant.effectToString(_pushing.cognitive)     + " " + Constant.effectToString(_pushing.strength)      + "\t" + (_pushing.valid? "T": "")       + "\t" + (_pushing.useful? "T": "")       + "\n";
			s += "3 | " + Constant.effectToString(_thirdstage.energy)  + "\t" + Constant.effectToString(_thirdstage.physical)  + "\t" + Constant.effectToString(_thirdstage.cognitive)  + "\t" + Constant.effectToString(_thirdstage.strength)  + "\t" + (_thirdstage.valid? "T": "")    + "\t" + (_thirdstage.useful? "T": "")    + "\n";"\n";
			
			return s;
		}
	}
}