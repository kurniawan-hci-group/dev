package birth.trainer {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	public class Test extends Sprite{
		public function Test()  {
			var request:URLRequest= new URLRequest ("http://users.soe.ucsc.edu/~fire/pp/pp-end.php");
			request.method = URLRequestMethod.POST;

			var variables:URLVariables = new URLVariables();
			
			variables["one[]"] = toArray({ time:"5:34", dilation:"10", card:"ActionCard5", reason:"Yes" });
			variables["two[]"] = toArray({ time:"5:34", dilation:"10", card:"ActionCard5"});
			request.data = variables;
			
            var urlLoader:URLLoader = new URLLoader (request);
            urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompletehandler);
            urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
            urlLoader.load(request);
        }
		private static function toArray(o:Object, reason:Boolean = true):Array {
			var a:Array = new Array;
			a[0] = o.time;
			a[1] = o.dilation;
			a[2] = o.card;
			if (reason) {
				a[3] = o.reason;
			}
			else {
				a[3] = "";
			}
			return a;
		}
        public function urlLoaderCompletehandler(event:Event) : void
        {
            var variables:URLVariables = new URLVariables( event.target.data );
             
            if (variables.error != null) trace("NO VARIABLES");
            else trace (event.target.data);
        
        }
	}
}