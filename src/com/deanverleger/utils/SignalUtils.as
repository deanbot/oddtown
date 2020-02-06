package com.deanverleger.utils
{
	import flash.display.InteractiveObject;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.natives.sets.InteractiveObjectSignalSet;

	public class SignalUtils
	{
		private static var signals:Dictionary;
		private static var downUpSignals:Dictionary;
		
		/**
		 *  
		 * @param ID - must be unique or you must be absolutely sure you are cleaning up before calling hookUp again
		 * @param mouseOver - mouse over handler (must take a MouseEvent paramater)
		 * @param mouseOut - mouse out hander ""
		 * @param click - click handler ""
		 * @param ... intObjects - list of interactive objects (comma separated)
		 * 
		 */
		public static function hookUpIntObjectSets(id:String, mouseOver:Function, mouseOut:Function, click:Function=null, ... intObjects ):void
		{
			if(!signals)
				signals=new Dictionary(true);
			if(signals[id])
				return;
			var objects:Dictionary=new Dictionary(true);
			var iObject:InteractiveObject;
			var set:InteractiveObjectSignalSet;
			for(var i:uint = 0; i < intObjects.length; i++)
			{
				iObject=InteractiveObject(intObjects[i]);
				if(iObject)
				{
					set=new InteractiveObjectSignalSet(iObject);
					objects[iObject]=set;
					set.mouseOver.add(mouseOver);
					set.mouseOut.add(mouseOut);
					if(click!=null)
						set.click.add(click);
				}
			}
			signals[id]=objects;
		}
		
		public static function hookUpDownUpSignals(id:String, mouseDown:Function=null, mouseUp:Function=null, ... intObjects ):void
		{
			if(!downUpSignals)
				downUpSignals=new Dictionary(true);
			if(downUpSignals[id])
				return;
			if(mouseDown==null && mouseUp==null)
				return;
			var objects:Dictionary=new Dictionary(true);
			var iObject:InteractiveObject;
			var set:InteractiveObjectSignalSet;
			for(var i:uint = 0; i < intObjects.length; i++)
			{
				iObject=InteractiveObject(intObjects[i]);
				if(iObject)
				{
					set=new InteractiveObjectSignalSet(iObject);
					objects[iObject]=set;
					if(mouseDown!=null)
						set.mouseDown.add(mouseDown);
					if(mouseUp!=null)
						set.mouseUp.add(mouseUp);
				}
			}
			downUpSignals[id]=objects;
		}
		
		public static function clearUpDownSignals(id:String):void
		{
			if(!downUpSignals)
				return;
			if(!downUpSignals[id])
				return;
			var dict:Dictionary=downUpSignals[id];
			for( var k:Object in dict)
			{
				InteractiveObjectSignalSet(dict[k]).removeAll();
				dict[k]=null;
				delete dict[k];
			}
			downUpSignals=null;
			signals[downUpSignals]=null;
			delete signals[downUpSignals];
		}
		
		public static function clearIntObjectSets(id:String):void
		{
			if(!signals)
				return;
			if(!signals[id])
				return;
			var dict:Dictionary=signals[id];
			for( var k:Object in dict)
			{
				InteractiveObjectSignalSet(dict[k]).removeAll();
				dict[k]=null;
				delete dict[k];
			}
			dict=null;
			signals[id]=null;
			delete signals[id];
		}
		
		public static function destroy():void
		{
			if(!signals)
				return;
			for( var k:String in signals)
			{
				SignalUtils.clearIntObjectSets(k);
			}
			DictionaryUtils.emptyDictionary(signals);
			signals=null;
		}
	}
}