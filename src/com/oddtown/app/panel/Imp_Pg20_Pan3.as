package com.oddtown.app.panel
{
	import com.greensock.TweenLite;
	import com.oddtown.engine.OddFlags;
	import com.oddtown.engine.PanelImp;
	
	public class Imp_Pg20_Pan3 extends PanelImp
	{
		//cactus
		private static const ID:String = "Imp_Pg20_Pan3";
		private static const FLAG_CACTUS_DROP:String="Cactus Drop";
		private static const FLAG_CACTUS_CATCH:String="Cactus Catch";
		private var panel:Pg20_Pan3;
		private var active:Boolean;
		
		public function Imp_Pg20_Pan3()
		{
			super();
		}
		
		override public function get hasPrepStep():Boolean { return true; }
		
		override public function panelPrep():void 
		{
			if(cactusCatched)
				_asset.gotoAndStop("pass");
			else
				_asset.gotoAndStop("fail");
		}
		
		override protected function panelCleanupEx():void
		{
			active=false;
			TweenLite.killDelayedCallsTo(change);
		}
		
		override protected function panelSetup():void
		{
			active=true;
			TweenLite.delayedCall(data.delay,change);
		}
		
		private function change():void
		{
			if(active)
				changePanel.dispatch(2);
		}
		
		private function get cactusCatched():Boolean { 
			var result:Boolean;
			var catched:Boolean=OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_CACTUS_CATCH);
			var dropped:Boolean=OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_CACTUS_DROP);
			if(catched)
				result=true;
			else if(dropped)
				result=false;
			else {
				//default to true
				result=true;
			}
			return result;
		}
	}
}