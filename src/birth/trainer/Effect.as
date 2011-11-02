package birth.trainer {
    public class Effect {
		private var _energy:Number;
		private var _physical:Number;
		private var _cognitive:Number;
		private var _strength:Number;
		private var _valid:Boolean;
		private var _useful:Boolean;
		

		public function Effect(
//			energy:Number,
//			physical:Number,
//			cognitive:Number,
//			strength:Number,
//			valid:Boolean
			) {
//			_energy    = energy;
//			_physical  = physical;
//			_cognitive = cognitive;
//			_strength  = strength;
//			_valid     = valid;
		}

		public function set energy(e:Number):void {
			_energy = e;
		}
		public function set physical(p:Number):void {
			_physical = p;
		}
		public function set cognitive(c:Number):void {
			_cognitive = c;
		}
		public function set strength(s:Number):void {
			_strength = s;
		}
		public function set valid(v:Boolean):void {
			_valid = v;
		}
		public function set useful(u:Boolean):void {
			_useful = u;
		}
		public function get energy():Number {
			return _energy;
		}
		public function get physical():Number {
			return _physical;
		}
		public function get cognitive():Number {
			return _cognitive;
		}
		public function get strength():Number {
			return _strength;
		}
		public function get valid():Boolean {
			return _valid;
		}
		public function get useful():Boolean {
			return _useful;
		}
		public function toString():String 
		{
			var s:String;
			s = "E: " + _energy + 
				"P: " + _physical +
				"C: " + _cognitive + 
				"S: " + _strength +
				"V: " + _valid + 
				"U: " + _useful;
			return s;
		}
	}		
}