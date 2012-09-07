package Vortex
{
	public class Global
	{

		public static var recentScore:int;
		public static var highScore:int;

		public function Global()
		{
			trace("Don't instantiate the global class.");
		}

		public static function Init():void
		{
			highScore = 0;
			recentScore = 0;
		}
	}
}