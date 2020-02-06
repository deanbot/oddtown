package com.oddtown.app.panel
{
	import com.deanverleger.utils.ClipUtils;
	import com.deanverleger.utils.SignalUtils;
	import com.greensock.TweenLite;
	import com.oddtown.app.ui.MouseIconHandler;
	import com.oddtown.engine.DisplayLink;
	import com.oddtown.engine.OddFlags;
	import com.oddtown.engine.PanelImp;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class Imp_Pg17_Pan2 extends PanelImp
	{
		private static const ID:String="Imp_Pg17_Pan2";
		private static const FLAG_DRAGGED_CHAO:String="p17 dragged chao";
		private static const FLAG_DRAGGED_MASON:String="p17 dragged mason";
		private static const LETTERS:Array=["i","j","k","l","m","n","o","p"];
		private var checkX:Number;
		private var checkY:Number;
		private var chaoDrag:Boolean;
		private var masonDrag:Boolean;
		private var enterFrame:NativeSignal;
		private var dragFolder:Sprite;
		private var panel:Pg17_Pan2;
		private var chaoFiled:Boolean;
		private var masonFiled:Boolean;
		private var failed:Boolean;
		private var currentGlow:String="";
		public function Imp_Pg17_Pan2()
		{
			super();
		}
		
		override public function get hasPrepStep():Boolean { return true; }
		
		override public function panelPrep():void
		{
			panel=Pg17_Pan2(_asset);
			//hide glow
			ClipUtils.hide(panel.glow_i,panel.glow_j,panel.glow_k,panel.glow_l,panel.glow_m,panel.glow_n,panel.glow_n,panel.glow_o,panel.glow_p);
			//hide drop
			ClipUtils.hide(panel.drop_i,panel.drop_j,panel.drop_k,panel.drop_l,panel.drop_m,panel.drop_n,panel.drop_n,panel.drop_o,panel.drop_p);
			//hide speech
			ClipUtils.hide(panel.speech_fail,panel.speech_pass);
			//hide small folders
			ClipUtils.hide(panel.chaoSmall,panel.masonSmall);
		}
		
		override protected function panelSetup():void
		{
			if(!panel)
				panel=Pg17_Pan2(_asset);
			hookUpFolders();
		}
		
		override protected function panelCleanupEx():void
		{
			if(panel)
			{
				TweenLite.killTweensOf(panel.speech_pass);
				TweenLite.killTweensOf(panel.speech_fail);
				TweenLite.killTweensOf(panel.hands_top);
				TweenLite.killTweensOf(panel.hands_bottom);
				TweenLite.killDelayedCallsTo(changePanel.dispatch);
			}
			SignalUtils.clearIntObjectSets(ID);
			SignalUtils.clearIntObjectSets(ID+'ud');
			SignalUtils.clearUpDownSignals(ID+'ud2');
			if(enterFrame)
				enterFrame.removeAll();
			enterFrame=null;
			dragFolder=null;
			panel=null;
		}
		
		private function hookUpFolders():void
		{
			currentGlow="";
			chaoDrag=masonDrag=false;
			dragFolder=null;
			SignalUtils.clearUpDownSignals(ID+'ud2');
			if(enterFrame)
				enterFrame.remove(onEnterFrame);
			if(!draggedChao&&!draggedMason)
			{
				SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,null,panel.chao.click,panel.mason.click);
				SignalUtils.hookUpDownUpSignals(ID+'ud',mouseDownOnFolder,null,panel.chao.click,panel.mason.click);
			}
			else if(!draggedChao)
			{
				SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,null,panel.chao.click);
				SignalUtils.hookUpDownUpSignals(ID+'ud',mouseDownOnFolder,null,panel.chao.click);
			}
			else
			{
				SignalUtils.hookUpIntObjectSets(ID,MouseIconHandler.mouseOver,MouseIconHandler.mouseOut,null,panel.mason.click);		
				SignalUtils.hookUpDownUpSignals(ID+'ud',mouseDownOnFolder,null,panel.mason.click);
			}
			enterFrame=new NativeSignal(_asset,Event.ENTER_FRAME,Event);
		}
		
		private function mouseDownOnFolder(e:MouseEvent):void
		{
			SignalUtils.clearIntObjectSets(ID);
			SignalUtils.clearIntObjectSets(ID+'ud');
			switch(e.target)
			{
				case panel.chao.click:
				case panel.chao:
					dragFolder=panel.chaoSmall;
					chaoDrag=true;
					dragFolder.x=_asset.mouseX-dragFolder.width*.5;
					dragFolder.y=_asset.mouseY-dragFolder.height*.5;
					ClipUtils.show(panel.chaoSmall);
					ClipUtils.hide(panel.chao);
					enterFrame.add(onEnterFrame);
					SignalUtils.hookUpDownUpSignals(ID+'ud2',null,checkFolderDrag,panel.chaoSmall);
					break;
				case panel.mason.click:
				case panel.mason:
					masonDrag=true;
					dragFolder=panel.masonSmall;
					dragFolder.x=_asset.mouseX-dragFolder.width*.5;
					dragFolder.y=_asset.mouseY-dragFolder.height*.5;
					ClipUtils.show(panel.masonSmall);
					ClipUtils.hide(panel.mason);
					enterFrame.add(onEnterFrame);
					SignalUtils.hookUpDownUpSignals(ID+'ud2',null,checkFolderDrag,panel.masonSmall);
					break;
			}
		}
		
		
		
		private function onEnterFrame(e:Event):void
		{
			if(!dragFolder)
				return;
			
			//move folder
			dragFolder.x=_asset.mouseX-dragFolder.width*.5;
			dragFolder.y=_asset.mouseY-dragFolder.height*.5;
			
			//check glow
			var globalPoint:Point;
			var localPoint:Point;
			if(chaoDrag)
			{
				globalPoint=panel.chaoSmall.bottom.localToGlobal(new Point(0,0));
				localPoint=panel.globalToLocal(globalPoint);
				checkX=localPoint.x;
				checkY=localPoint.y+130;
			} else if(masonDrag)
			{
				globalPoint=panel.masonSmall.bottom.localToGlobal(new Point(0,0));
				localPoint=panel.globalToLocal(globalPoint);
				checkX=localPoint.x;
				checkY=133+localPoint.y;
			} else {
				return;
			}
			var found:Boolean;
			var i:uint=0;
			var drop:DisplayObject;
			while(!found && i<LETTERS.length)
			{
				//trace(LETTERS[i]);
				drop=DisplayObjectContainer(panel["drop_"+LETTERS[i]]);
				if(drop.hitTestPoint(checkX,checkY,true))
				{
					found=true;
				} else {
					i++;
				}
			}
			if(found)
			{
				if(currentGlow)
					ClipUtils.hide(DisplayObject(panel["glow_"+currentGlow]));
				currentGlow=LETTERS[i];
				ClipUtils.show(DisplayObject(panel["glow_"+currentGlow]));
			} else {
				if(currentGlow)
					ClipUtils.hide(DisplayObject(panel["glow_"+currentGlow]));
				currentGlow='';
			}
		}
		
		private function checkFolderDrag(e:MouseEvent):void
		{
			SignalUtils.clearUpDownSignals(ID+'ud2');
			MouseIconHandler.showArrowIcon();
			enterFrame.remove(onEnterFrame);
			dragFolder=null;
			if(currentGlow)
			{
				ClipUtils.hide(DisplayObject(panel["glow_"+currentGlow]));
				if(chaoDrag)
				{
					if(draggedChao)
						return;
					trace("chao filed");
					draggedChao=true;
					ClipUtils.hide(panel.chaoSmall);
					if(currentGlow!="l")
						failed=true;
					else
						trace("chao succes");
				} else if(masonDrag)
				{
					if(draggedMason)
						return;
					trace("mason filed");
					draggedMason=true;
					ClipUtils.hide(panel.masonSmall);
					if(currentGlow!="j")
						failed=true;
					else
						trace("mason success");
				}	
				if(draggedMason&&draggedChao)
					calculateSuccess();
				else
					sendBack();
			} else
				sendBack();
		} 
		
		private function sendBack():void
		{
			if(chaoDrag)
			{
				ClipUtils.hide(panel.chaoSmall);
				if(!draggedChao)
					ClipUtils.show(panel.chao);
				hookUpFolders();	
			} 
			else if (masonDrag)
			{
				ClipUtils.hide(panel.masonSmall);
				if(!draggedMason)
					ClipUtils.show(panel.mason);
				hookUpFolders();
			}	
		}
		
		private function calculateSuccess():void
		{
			if(failed)
			{
				OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG,"Failed Filing");
				panel.speech_fail.visible=true;
				TweenLite.to(panel.speech_fail,.5,{alpha:1,onComplete:onPopup});
			} else {
				OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG,"Passed Filing");
				panel.speech_pass.visible=true;
				TweenLite.to(panel.speech_pass,.5,{alpha:1,onComplete:onPopup});
			}
		}
		
		private function onPopup():void
		{
			TweenLite.to(panel.hands_top,.5,{alpha:0});
			TweenLite.to(panel.hands_bottom,.5,{alpha:0});
			TweenLite.delayedCall(1.5,changePanel.dispatch,[3]);
		}
		
		private function get draggedMason():Boolean
		{
			return OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_DRAGGED_MASON);
		}
		
		private function set draggedMason(val:Boolean):void
		{
			if(val)
				OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_DRAGGED_MASON);
		}
		
		private function get draggedChao():Boolean
		{
			return OddFlags.getFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_DRAGGED_CHAO);
		}
		
		private function set draggedChao(val:Boolean):void
		{
			if(val)
				OddFlags.setFlag(OddFlags.FLAG_TYPE_FLAG,FLAG_DRAGGED_CHAO);
		}
	}
}