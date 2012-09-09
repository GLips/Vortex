package Vortex
{

	import Framework.Utils.FSave;

	public class Global
	{

		public static var recentScore:int;
		public static var highScore:int;
		public static var hasPlayed:Boolean;

		public static const saveName:String = "Vortex";

		public function Global()
		{
			trace("Don't instantiate the global class.");
		}

		public static function Init():void
		{
			highScore = 0;
			recentScore = 0;
			hasPlayed = false;
		}

		public static function Load():void
		{
			var a:Array = FSave.Load(saveName);

			if(a != null)
			{
				highScore = a["highScore"];
				recentScore = a["recentScore"];
				hasPlayed = a["hasPlayed"];
			}
		}

		public static function Save():void
		{
			var a:Array = new Array();
			a["highScore"] = highScore;
			a["recentScore"] = recentScore;
			a["hasPlayed"] = hasPlayed;

			FSave.Save(a, saveName);
		}

		public static function Clear():void
		{
			Init();
			FSave.Clear(saveName);
		}
	}
}