package com.oddtown.engine.sound
{
	import com.deanverleger.core.IDestroyable;
	import com.deanverleger.utils.AssetUtils;
	import com.deanverleger.utils.DictionaryUtils;
	
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;

	public class SoundLibrary implements IDestroyable
	{
		// constants:
		public static const ID:String="SoundLibrary";
		
		// private properties:
		private var _parseComplete:Signal;
		private var _soundInstructions:Dictionary;
		private var _musicSoundObjects:Dictionary;
		private var _ambientSoundObjects:Dictionary;
		
		// public properties:
		// constructor:
		public function SoundLibrary()
		{
			_parseComplete=new Signal(String);
			_soundInstructions = new Dictionary(true);
			_musicSoundObjects = new Dictionary(true);
			_ambientSoundObjects = new Dictionary(true);
		}
		
		// public getter/setters:
		public function get parseComplete():Signal
		{
			return _parseComplete;
		}
		
		// public methods:
		public function build(data:XMLList):void
		{
			trace("parsing sound data");
			var soundInstructionsData:XML = data.soundInstructions[0];
			var soundObjectsData:XML=data.soundObjects[0]
			if(soundInstructionsData == null || soundObjectsData == null)
				return;
			for each(var instructionData:XML in soundInstructionsData.soundInstruction)
			{
				var k:String = String(instructionData.@key);
				if(k==null)
					throw new Error("Sound Instruction Manager: Sound Instruction has no key.");
				_soundInstructions[k] = parseSoundInstruction(instructionData);
			};
			var enumerationPackage:String = String(soundObjectsData.@enumerationPackage);
			var enumerationClassName:String = String(soundObjectsData.@enumerationClassName);
			if(enumerationClassName==null)
				throw new Error("Sound Instruction Manager: Sound Objects have no Enumeration Class Name.");
			for each(var mObjectData:XML in soundObjectsData.music.soundObject)
			{
				var key:String = String(mObjectData.@key);
				if(key==null)
					throw new Error("Sound Instruction Manager: Sound Object has no key.");
				var className:String = String(mObjectData.@className);
				if(className==null)
					throw new Error("Sound Instruction Manager: Sound Object has class name.");
				_musicSoundObjects[key] = parseSoundObject(mObjectData);
			}
			for each(var aObjectData:XML in soundObjectsData.ambient.soundObject)
			{
				var aKey:String = String(aObjectData.@key);
				if(aKey==null)
					throw new Error("Sound Instruction Manager: Sound Object has no key.");
				var aClassName:String = String(aObjectData.@className);
				if(aClassName==null)
					throw new Error("Sound Instruction Manager: Sound Object has class name.");
				_ambientSoundObjects[aKey] = parseSoundObject(aObjectData);
			}
			_parseComplete.dispatch(ID);
		}
		
		public function destroy():void
		{
			trace("destroy SoundLibrary");
			_parseComplete.removeAll();
			_parseComplete=null;
			DictionaryUtils.emptyDictionary(_soundInstructions,true);
			DictionaryUtils.emptyDictionary(_musicSoundObjects);
			DictionaryUtils.emptyDictionary(_ambientSoundObjects);
		}
		
		public function getSoundInstruction(soundInstructionKey:String):SoundInstruction
		{
			var instruction:SoundInstruction=_soundInstructions[soundInstructionKey];
			return instruction;
		}
		
		public function getSoundObject(soundObjectKey:String,type:String):SoundObject
		{
			var s:SoundObject;
			if(type==SoundObjectType.MUSIC)
			{
				if(_musicSoundObjects[soundObjectKey])
					s = _musicSoundObjects[soundObjectKey];
			} else if(type==SoundObjectType.AMBIENT)
			{
				if(_ambientSoundObjects[soundObjectKey])
					s = _ambientSoundObjects[soundObjectKey];
			}
			return s;
		}
		
		public function getSoundInstructionObject(soundInstructionKey:String, soundObjectKey:String, type:String):SoundInstructionObject
		{
			var s:SoundInstructionObject;
			if(_soundInstructions[soundInstructionKey])
			{
				if(type==SoundObjectType.MUSIC)
					s = SoundInstruction(_soundInstructions[soundInstructionKey]).musicInstructionObjects[soundObjectKey] as SoundInstructionObject;
				else if(type==SoundObjectType.AMBIENT)
					s = SoundInstruction(_soundInstructions[soundInstructionKey]).ambientInstructionObjects[soundObjectKey] as SoundInstructionObject;
			}
			return s;
		}
		
		// private methods:
		private function parseSoundInstruction(instructionData:XML):SoundInstruction
		{
			var key:String = String(instructionData.@key);
			var musicObjects:XMLList = XMLList(instructionData.music);
			var ambientObjects:XMLList = XMLList(instructionData.ambient);
			return new SoundInstruction(key,musicObjects,ambientObjects);
		}
		
		private function parseSoundObject(objectData:XML):SoundObject
		{
			var key:String = String(objectData.@key);
			var className:String = String(objectData.@className);
			return new SoundObject(key,className);
		}
	}
}