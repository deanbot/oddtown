package com.oddtown.engine
{
	import com.deanverleger.core.IDestroyable;
	import com.gskinner.utils.FrameScriptManager;
	
	import flash.display.MovieClip;
	
	import org.osflash.signals.Signal;

	public class PanelImp implements IDestroyable
	{
		protected var _asset:MovieClip;
		private var _oPanel:OddPanel;
		private var _frameEndReached:Signal;
		protected var fsm:FrameScriptManager;
		private var _changePanel:Signal;
		private var _setTree:Signal;
		private var _pageEndReached:Signal;
		private var _lostGame:Signal;
		public function PanelImp()
		{
			//trace("construct panel Imp");
			_frameEndReached=new Signal();
			_changePanel=new Signal(uint);
			_setTree=new Signal(String);
			_pageEndReached=new Signal(uint);
			_lostGame=new Signal();
		}
		
		public function get lostGame():Signal
		{
			return _lostGame;
		}

		public function get pageEndReached():Signal
		{
			return _pageEndReached;
		}

		public function get setTree():Signal
		{
			return _setTree;
		}

		public function get changePanel():Signal
		{
			return _changePanel;
		}

		/**
		 * Override in child class. This is a hook. See panelPrep comments
		 * 
		 */
		public function get hasPrepStep():Boolean
		{
			return false;
		}
		
		public function get frameEndReached():Signal
		{
			return _frameEndReached;
		}

		public function set data(oPanel:OddPanel):void
		{
			_oPanel=oPanel;
		}
		
		public function get data():OddPanel
		{
			return _oPanel;
		}
		
		public function set asset(mc:MovieClip):void
		{
			_asset=mc;
		}
		
		public function get asset():MovieClip
		{
			return _asset;
		}
		
		public function get autoProgress():Boolean
		{
			return _oPanel.autoProgress;
		}
		
		public final function destroy():void
		{
			//trace("destroy panel imp");
			panelCleanup();
			_frameEndReached.removeAll();
			_frameEndReached=_changePanel=_setTree=_pageEndReached=_lostGame=null;
			if(_asset)
			{
				if(_asset.isPlaying)
					_asset.stop();
				_asset=null;
			}
		}
		
		public final function panelCleanup():void
		{
			panelCleanupEx();
			_setTree.removeAll();
			_changePanel.removeAll();
			_pageEndReached.removeAll();
			_lostGame.removeAll();
		}
		
		public final function play():void
		{
			if(!_asset||!_oPanel)
				return;
			panelSetup();
			if(_oPanel.autoProgress)
			{
				if(!fsm)
				{
					fsm = new FrameScriptManager(_asset);
					fsm.setFrameScript(_asset.totalFrames,signalFrameEndReached);
				}
				_asset.play();
			}
		}
		
		public function stop():void
		{
			if(!_asset||!_oPanel)
				return;
			if(_oPanel.autoProgress)
			{
				_asset.stop();
			}
		}
		
		/**
		 * Override in child class if your panel needs to hide things or do other setup before being revealed
		 * 
		 */
		public function panelPrep():void
		{
			
		}
		
		/**
		 * Override in child class if your panel needs to set up listeners or new assets
		 * 
		 */
		protected function panelSetup():void
		{
			
		}

		/**
		 * Override in child class if your panel needs to clean up listeners
		 * 
		 */
		protected function panelCleanupEx():void
		{
			
		}
		
		/**
		 *  
		 * @param pageID page order to go to. leave 0 to go to 'next' page
		 * 
		 */
		protected function signalPageEndReached(pageID:uint=0):void
		{
			//trace('signal page end reached');
			if(_pageEndReached)
				_pageEndReached.dispatch(pageID);
		}
		
		private function signalFrameEndReached():void
		{
			if(_asset.isPlaying)
				_asset.stop();
			panelCleanup();
			_frameEndReached.dispatch();
		}
	}
}