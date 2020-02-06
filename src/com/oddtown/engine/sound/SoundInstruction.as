package com.oddtown.engine.sound
{
	import com.deanverleger.core.IDestroyable;
	import com.deanverleger.utils.DictionaryUtils;
	
	import flash.utils.Dictionary;

	public class SoundInstruction implements IDestroyable
	{
		private var _key:String;
		private var _musicInstructionObjects:Dictionary;
		private var _ambientInstructionObjects:Dictionary;
		
		public function SoundInstruction(key:String,musicObjects:XMLList=null,ambientObjects:XMLList=null)
		{
			_key = key;
			_musicInstructionObjects = new Dictionary(true);
			var k:String;
			for each (var musicObject:XML in musicObjects)
			{
				k = String(musicObject.@soundObjectKey);
				if(k==null)
					throw new Error("Sound Object["+_key+"]: Sound Instruction Object (music) has no sound object key.");
				_musicInstructionObjects[k] = getSoundInstructionObject(musicObject);
			}
			_ambientInstructionObjects = new Dictionary(true);
			for each (var ambientObject:XML in ambientObjects)
			{
				k = String(ambientObject.@soundObjectKey);
				if(k==null)
					throw new Error("Sound Object["+_key+"]: Sound Instruction Object (ambient) has no sound object key.");
				_ambientInstructionObjects[k] = getSoundInstructionObject(ambientObject);
			}
	
		}
			
		public function set musicInstructionObjects(value:Dictionary):void
		{
			_musicInstructionObjects = value;
		}

		public function set ambientInstructionObjects(value:Dictionary):void
		{
			_ambientInstructionObjects = value;
		}

		public function get key():String
		{
			return _key;
		}
		
		public function get musicInstructionObjects():Dictionary
		{
			return _musicInstructionObjects;
		}
		
		public function get ambientInstructionObjects():Dictionary
		{
			return _ambientInstructionObjects;
		}
		
		public function destroy():void
		{
			DictionaryUtils.emptyDictionary(_musicInstructionObjects);
			DictionaryUtils.emptyDictionary(_ambientInstructionObjects);
			_musicInstructionObjects = _ambientInstructionObjects = null;
			_key = null;
		}
		
		private function getSoundInstructionObject(data:XML):SoundInstructionObject
		{
			var key:String = String(data.@soundObjectKey);
			var loop:Boolean = ( String(data.@loop) == 'true' ) ? true : false;
			var volume:Number = ( String(data.@volume) != '' ) ? Number(data.@volume) : 1;
//			var nextKey:String = String(data.@nextSoundObjectKey);
			return new SoundInstructionObject(key, loop, volume /*,nextKey*/);
		}
	}
}