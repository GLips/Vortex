package Vortex.Particles
{
	import Framework.FParticle;

	public class PlanetDebris extends FParticle
	{

		public var c:Number = 0;
		public var r:Number;

		public function PlanetDebris()
		{
			super();
			r = Math.random() * 4 + 1;
		}

		override public function Draw():void
		{
			graphics.clear();
			graphics.beginFill(c);
			graphics.drawEllipse(0,0,r,r);
			graphics.endFill();

			draws = false;
		}
	}
}