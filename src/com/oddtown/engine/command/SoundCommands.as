package com.oddtown.engine.command
{
	import com.deanverleger.core.IDestroyable;
	import com.oddtown.engine.sound.SoundInstruction;
	import com.oddtown.engine.sound.SoundInstructionObject;
	import com.oddtown.engine.sound.SoundLibrary;
	import com.oddtown.engine.sound.SoundObject;
	
	import flash.media.Sound;
	import flash.utils.Dictionary;

	public class SoundCommands implements IDestroyable
	{
		private var soundLibrary:SoundLibrary;
		public function SoundCommands(lib:SoundLibrary)
		{
			soundLibrary=lib;
		}
		
		public function getSoundInstruction(soundInstructionKey:String):SoundInstruction
		{
			return soundLibrary.getSoundInstruction(soundInstructionKey);
		}
		
		public function getSoundObject(soundObjectKey:String,type:String):SoundObject
		{
			return soundLibrary.getSoundObject(soundObjectKey,type);
		}
		
		public function getSoundInstructionObject(soundInstructionKey:String, soundObjectKey:String, type:String):SoundInstructionObject
		{
			return soundLibrary.getSoundInstructionObject(soundInstructionKey, soundObjectKey, type);
		}
		
		public function destroy():void
		{
			soundLibrary=null;
		}
	}
}