package birth.trainer {
	// http://board.flashkit.com/board/showthread.php?t=807917&highlight=high+score

	import flash.net.SharedObject;
	
	class HighScores {
		private var scoresArray:Array = new Array();
		private var namesArray:Array = new Array();
		private var user_create = SharedObject.getLocal("user");
		
		
		public function HighScores() {
			if (user_create.data.score1 == undefined) {
				for (i=1; i<=5; i++) {
					user_create.data["score"+i] = 0;
					user_create.data["name"+i] = "No score";
				}
			}
			for (k=0; k<=4; k++) {
				scoresArray[k] = user_create.data["score"+(k+1)];
				namesArray[k] = user_create.data["name"+(k+1)];
				this["score"+(k+1)+"_entry"] = scoresArray[k];
				this["name"+(k+1)+"_entry"] = namesArray[k];
			}
			// 
			for (j=0; j<=4; j++) {
				if (_root.score>scoresArray[j]) {
					scoresArray.splice(j,0,_root.score);
					namesArray.splice(j,0,name_enter);
					scoresArray.pop();
					namesArray.pop();
					break;
				}
			}
			for (k=0; k<=4; k++) {
				user_create.data["score"+k] = scoresArray[k];
				user_create.data["name"+k] = namesArray[k];
				this["score"+(k+1)+"_entry"] = scoresArray[k];
				this["name"+(k+1)+"_entry"] = namesArray[k];
			}
			user_create.flush();
			//
		}
	}
}