package com.oddtown.app.panel.test
{
	import com.deanverleger.utils.ClipUtils;
	import com.deanverleger.utils.SignalUtils;
	import com.gskinner.utils.FrameScriptManager;
	import com.oddtown.app.ui.MouseIconHandler;
	import com.oddtown.app.ui.UIInterface;
	import com.oddtown.engine.OddFlags;
	import com.oddtown.engine.PanelIDUtils;
	import com.oddtown.engine.PanelImp;
	
	import flash.events.MouseEvent;
	
	public class Test_Imp_Pg2_Pan1 extends PanelImp
	{
		private var panel:Test_Pg2_Pan1;
		
		private static const ID:String = "Test_Imp_Pg2_Pan1";
		private static const ORDER_CACTUS:uint=2;
		private static const ORDER_CAMERA:uint=3;
		private static const ORDER_BATHROOM:uint=4;
		
		public function Test_Imp_Pg2_Pan1()
		{
			trace("construct panel Test_Imp_Pg2_Pan1");
			super();
		}
		
		override protected function panelSetup():void
		{		
			panel=Test_Pg2_Pan1(_asset);
			if(!OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,"Saw room transition"))
			{
				// if hasn't viewed
				fsm=new FrameScriptManager(_asset);
				fsm.setFrameScript(_asset.totalFrames, tweenFinished);
				_asset.play();
			} else 
			{
				//if has viewed
				SignalUtils.hookUpIntObjectSets(ID,onMouseOver,onMouseOut,onClick,
					panel.cactus, panel.camera, panel.desk, panel.bathroom, panel.cabinet, panel.chair, panel.bookcase);
			}
			if(OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,"Tub Discovered"))
			{
				UIInterface.showArrows(true,true);
				UIInterface.nextArrowClicked.addOnce(moveForward);
				UIInterface.prevArrowClicked.addOnce(moveBackward);
			}
		}
		
		override public function get hasPrepStep():Boolean
		{
			var doPrep:Boolean = OddFlags.getFlag(OddFlags.FLAG_TYPE_VIEWED,PanelIDUtils.getPanelViewedID(data.parent.pageOrder,data.order,data.tree));
			return doPrep;
		}
		
		override public function panelPrep():void
		{
			_asset.gotoAndStop(_asset.totalFrames);
			panel=Test_Pg2_Pan1(_asset);
			ClipUtils.makeInvisible(panel.bookcase, panel.cabinet, panel.cactus, panel.camera, panel.chair, panel.desk, panel.bathroom);
		}
		
		private function moveForward():void
		{
			signalPageEndReached();
		}
		
		private function moveBackward():void
		{
			signalPageEndReached(data.parent.prevPage);
		}
		
		override protected function panelCleanupEx():void
		{
			trace("Cleanup");
			SignalUtils.clearIntObjectSets(ID);
			fsm=null;
			panel=null;
		}
		
		private function tweenFinished():void
		{
			_asset.stop();
			ClipUtils.makeInvisible(panel.bookcase, panel.cabinet, panel.cactus, panel.camera, panel.chair, panel.desk, panel.bathroom);
			OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG, "Saw room transition");
			/*
			//cactus
			cactusClick=new InteractiveObjectSignalSet(panel.cactus);
			cactusClick.mouseOver.add(onMouseOver);
			cactusClick.mouseOut.add(onMouseOut);
			cactusClick.click.add(onClick);
			//camera
			cameraClick=new InteractiveObjectSignalSet(panel.camera);
			cameraClick.mouseOver.add(onMouseOver);
			cameraClick.mouseOut.add(onMouseOut);
			cameraClick.click.add(onClick);
			//desk
			deskClick=new InteractiveObjectSignalSet(panel.desk);
			deskClick.mouseOver.add(onMouseOver);
			deskClick.mouseOut.add(onMouseOut);
			deskClick.click.add(onClick);
			//bathroom
			bathroomClick=new InteractiveObjectSignalSet(panel.bathroom);
			bathroomClick.mouseOver.add(onMouseOver);
			bathroomClick.mouseOut.add(onMouseOut);
			bathroomClick.click.add(onClick);
			//bookcase
			bookcaseClick=new InteractiveObjectSignalSet(panel.bookcase);
			bookcaseClick.mouseOver.add(onMouseOver);
			bookcaseClick.mouseOut.add(onMouseOut);
			bookcaseClick.click.add(onClick);
			//cabinet
			cabinetClick=new InteractiveObjectSignalSet(panel.cabinet);
			cabinetClick.mouseOver.add(onMouseOver);
			cabinetClick.mouseOut.add(onMouseOut);
			cabinetClick.click.add(onClick);
			//chair
			chairClick=new InteractiveObjectSignalSet(panel.chair);
			chairClick.mouseOver.add(onMouseOver);
			chairClick.mouseOut.add(onMouseOut);
			chairClick.click.add(onClick);*/
			SignalUtils.hookUpIntObjectSets(ID,onMouseOver,onMouseOut,onClick,
				panel.cactus, panel.camera, panel.desk, panel.bathroom, panel.cabinet, panel.chair, panel.bookcase);
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			trace("Over: " + e.target.name);
			MouseIconHandler.showHoverIcon();
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			trace("Out: " + e.target.name);
			MouseIconHandler.showArrowIcon();
		}
		
		private function onClick(e:MouseEvent):void
		{
			switch(e.target)
			{
				case panel.cactus:
					changePanel.dispatch(ORDER_CACTUS);
					break;
				case panel.camera:
					changePanel.dispatch(ORDER_CAMERA);
					break;
				case panel.bathroom:
					changePanel.dispatch(ORDER_BATHROOM);
					break;
				default:
					trace("Click: " + e.target.name);
					
			}
		}
	}
}