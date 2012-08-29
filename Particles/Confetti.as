package Vortex.Particles
{

	import Framework.FParticle;
	import Framework.Utils.FArray;
	import Framework.Maths.FMath;

	public class Confetti extends FParticle
	{
		public var colors:Array;

		private var c:uint;
		private var h:int;
		private var w:int;

		// So not all confetti is scaling at the same speed
		private var randomOffset:Number;

		public function Confetti()
		{
			super();

			h = 2;
			w = Math.round(FMath.Random(4, 6));
		}

		override public function Create():void
		{
			super.Create();

			colors = new Array(
				0xDE3E7E // Pink
			,	0xDB2C2C // Red
			,	0x952CDB // Purple
			,	0x3420E6 // Blue
			,	0x2076E6 // Light blue
			,	0x2BBA5F // Light green
			,	0x2A8C32 // Green
			,	0xF0EC1A // Yellow
			,	0xF0971A // Orange
			);

			randomOffset = FMath.Random(-100, 100);

			// Pick a random color!
			c = FArray.GetRandom(colors);

			spin = FMath.Random(-15 * velocity.x, 15 * velocity.x);
		}

		override public function Draw():void
		{
			graphics.clear();
			graphics.beginFill(c);
			graphics.drawRect(-w,-h,w*2,h*2);
			graphics.endFill();
			draws = false;
		}

		override public function Update():void
		{
			super.Update();

			scaleY = Math.abs(Math.sin((timeLived * 5) + randomOffset)) * 0.75 + 0.25;

			//trace(Math.sin(lifetime));
			//acceleration = ;
		}
	}
}