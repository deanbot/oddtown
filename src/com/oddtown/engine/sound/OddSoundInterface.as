package com.oddtown.engine.sound
{
	import flash.media.Sound;

	public class OddSoundInterface
	{
		private static var initialized:Boolean;
		private static var _oddSounds:OddSounds;
		
		public static function initialize(oddSounds:OddSounds):void
		{
			_oddSounds=oddSounds;
			initialized=true;
		}
		
		public static function activateSoundObject(soundInstructionKey:String):void
		{
			_oddSounds.activateSoundInstruction(soundInstructionKey);
		}
		
		public static function manageSoundChannelRemoval(currentSoundInstructionKey:String,destinationSoundInstructionKey:String=null):void
		{
			_oddSounds.manageSoundChannelRemoval(currentSoundInstructionKey,destinationSoundInstructionKey);
		}
		
		public static function stopAllSounds(time:Number=.3,fade:Boolean=true,callback:Function=null,removeOnComplete:Boolean=true):void
		{
			if(_oddSounds.isPlaying)
				_oddSounds.stopAllSounds(time,fade,callback,removeOnComplete);
		}
		
		public static function get isPlaying():Boolean
		{
			return _oddSounds.isPlaying;
		}
		
		public static function get muted():Boolean
		{
			return _oddSounds.muted;
		}
		
		public static function set muted(value:Boolean):void
		{
			_oddSounds.muted = value;
		}
		
		public static function destroy():void
		{
			_oddSounds=null;
			initialized=false;
		}
		
		public static function playUISound( sound:Sound, callback:Function, _name:String, ignorePreviousCallback:Boolean = false, volumeMultiplier:Number = -1 ):void
		{
			_oddSounds.playUISound(sound,callback,_name,ignorePreviousCallback,volumeMultiplier);
		}
		
		public static function playSingleSound(key:String, sound:Sound, volume:Number = 1, callback:Function = null):void
		{
			_oddSounds.playSingleSound(key,sound,volume,callback);
		}
		
		public static function playSingleSoundObject(key:String, type:String, vol:Number = 1, callback:Function = null):void
		{
			_oddSounds.playSingleSoundObject(key,type,vol,callback);
		}
		
		public static function stopSingleSound(key:String, ignoreCallback:Boolean = true):void
		{
			_oddSounds.stopSingleSound(key,ignoreCallback);
		}
		
		public static function fadeSingleSound(key:String, to:Number, duration:Number, callback:Function = null):void
		{
			_oddSounds.fadeSingleSound(key,to,duration,callback);
		}
	}
}