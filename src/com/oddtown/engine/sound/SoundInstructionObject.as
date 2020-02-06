package com.oddtown.engine.sound
{
	public class SoundInstructionObject
	{
		private var _soundObjectKey:String;
		private var _loop:Boolean;
		private var _volume:Number;
		private var _nextSoundObjectKey:String;
		private var _playAtStart:Boolean;
		public function SoundInstructionObject(key:String,loopObject:Boolean,rawVolume:Number,nextKey:String=null)
		{
			_soundObjectKey = key;
			_loop = loopObject;
			if(rawVolume<0)
				throw new Error("Sound Instruction Object Volume cannot be negative");
			if(rawVolume>1)
				_volume = rawVolume*.01;
			else
				_volume = rawVolume;
			_nextSoundObjectKey = nextKey;
		}
		
		public function get soundObjectKey():String
		{
			return _soundObjectKey;
		}
		
		public function get loop():Boolean
		{
			return _loop;
		}
		
		public function get volume():Number
		{
			return _volume;
		}
		
		public function get nextSoundObjectKey():String
		{
			return _nextSoundObjectKey;
		}
	}
}