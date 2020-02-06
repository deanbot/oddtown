package com.oddtown.engine.sound
{
	import com.deanverleger.core.IDestroyable;
	import com.deanverleger.sound.BaseSoundObject;
	import com.deanverleger.utils.AssetUtils;
	import com.deanverleger.utils.DictionaryUtils;
	import com.deanverleger.utils.LoggingUtils;
	import com.greensock.TweenLite;
	import com.oddtown.engine.OddConfig;
	import com.oddtown.engine.command.SoundCommands;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.osflash.signals.natives.NativeSignal;

	public class OddSounds implements IDestroyable
	{
		// constants:
		public static const LOCATION:String = "OddSounds";
		// private properties:
		private var _soundLibraryCommands:SoundCommands;
		private var _isPlaying:Boolean;
		private var _muted:Boolean;
		private var _globalVolume:Number;
		private var _uiVolumeOffset:Number;
		private var _musicVolumeOffset:Number;
		private var _ambientVolumeOffset:Number;
		private var _uiSoundFinished:NativeSignal;
		private var _uiSoundChannel:SoundChannel;
		private var _uiSoundTransform:SoundTransform;	
		private var _numAmbientSoundChannels:uint;
		private var _numMusicSoundChannels:uint;
		private var musicChannelsFadedCountdown:uint;
		private var ambientChannelsFadedCountdown:uint;
		private var _uiCallbacks:Dictionary;
		private var _musicSoundChannels:Dictionary;
		private var _ambientSoundChannels:Dictionary;
		private var _musicFinishedCallbacks:Dictionary;
		private var _ambientFinishedCallbacks:Dictionary;
		private var _musicSoundTransforms:Dictionary;
		private var _ambientSoundTransforms:Dictionary;
		private var _musicObjectVolumes:Dictionary;
		private var _ambientObjectVolumes:Dictionary;
		private var _fadeMusicTimers:Dictionary;
		private var _fadeAmbientTimers:Dictionary;
		private var _onFadeMusicTimer:Dictionary;
		private var _onFadeAmbientTimer:Dictionary;
		private var _currentUISound:String = "";
		private var singleSounds:Dictionary;
		private var singleSoundIgnoreCallback:Dictionary;
		
		// public properties:
		// constructor:
		public function OddSounds()
		{
			OddSoundInterface.initialize(this);
			_uiCallbacks = new Dictionary(true);
			_uiSoundTransform = new SoundTransform();
			_musicSoundChannels = new Dictionary(true);
			_ambientSoundChannels = new Dictionary(true);
			_musicFinishedCallbacks= new Dictionary(true);
			_ambientFinishedCallbacks = new Dictionary(true);
			_musicSoundTransforms = new Dictionary(true);
			_ambientSoundTransforms = new Dictionary(true);
			_musicObjectVolumes  = new Dictionary(true);
			_ambientObjectVolumes = new Dictionary(true);
			_fadeMusicTimers =new Dictionary(true);
			_fadeAmbientTimers =new Dictionary(true);
			_onFadeMusicTimer =new Dictionary(true);
			_onFadeAmbientTimer =new Dictionary(true);
			_currentUISound = "";
			singleSounds = new Dictionary(true);
			singleSoundIgnoreCallback = new Dictionary(true);
		}
		
		// public getter/setters:
		public function get muted():Boolean
		{
			return _muted;
		}

		public function set muted(value:Boolean):void
		{
			_muted = value;
		}

		public function get isPlaying():Boolean
		{
			return playingMusic||playingMusic;
		}

		public function set soundLibraryCommands(cmds:SoundCommands):void
		{
			_soundLibraryCommands=cmds;
		}
		
		// public methods:
		public function activateSoundInstruction(instructionKey:String):void
		{
			var i:Object;
			var instructionObjectSets:Dictionary;
			var instructionObject:SoundInstructionObject;
			var currentInstructionObjects:Dictionary;
			var currentSoundInstruction:SoundInstruction=_soundLibraryCommands.getSoundInstruction(instructionKey);
			LoggingUtils.msgTrace(instructionKey,LOCATION + ".activateSoundInstruction()");
			
			if(playingMusic)
			{
				//playing similar music. only play new music
				currentInstructionObjects = getPlayingKeys(SoundObjectType.MUSIC);
				instructionObjectSets=currentSoundInstruction.musicInstructionObjects;
				for(i in instructionObjectSets)
				{
					if(currentInstructionObjects[i] == null)
					{
						instructionObject = SoundInstructionObject(instructionObjectSets[i]);
//						if(instructionObject.playAtStart)
							playSoundObject(SoundObjectType.MUSIC,instructionObject.soundObjectKey,instructionKey,instructionObject.volume,instructionObject.loop,instructionObject.nextSoundObjectKey);
					}
				}
			} else
			{
				instructionObjectSets=currentSoundInstruction.musicInstructionObjects;
				for(i in instructionObjectSets)
				{
					instructionObject = SoundInstructionObject(instructionObjectSets[i]);
//					if(instructionObject.playAtStart)
						playSoundObject(SoundObjectType.MUSIC,instructionObject.soundObjectKey,instructionKey,instructionObject.volume,instructionObject.loop,instructionObject.nextSoundObjectKey);
				}
			}
			
			if(playingAmbient)
			{
				//playing similar ambient. only play new ambient
				currentInstructionObjects = getPlayingKeys(SoundObjectType.AMBIENT);
				instructionObjectSets=currentSoundInstruction.ambientInstructionObjects;
				for(i in instructionObjectSets)
				{
					if(currentInstructionObjects[i] == null)
					{
						instructionObject = SoundInstructionObject(instructionObjectSets[i]);
//						if(instructionObject.playAtStart)
							playSoundObject(SoundObjectType.AMBIENT,instructionObject.soundObjectKey,instructionKey,instructionObject.volume,instructionObject.loop,instructionObject.nextSoundObjectKey);
					}
				}
			} else
			{
				instructionObjectSets=currentSoundInstruction.ambientInstructionObjects;
				for(i in instructionObjectSets)
				{
					instructionObject = SoundInstructionObject(instructionObjectSets[i]);
//					if(instructionObject.playAtStart)	
						playSoundObject(SoundObjectType.AMBIENT,instructionObject.soundObjectKey,instructionKey,instructionObject.volume,instructionObject.loop,instructionObject.nextSoundObjectKey);
				}
			}
		}
		
		public function manageSoundChannelRemoval(currentSoundInstructionKey:String,destinationSoundInstructionKey:String=null):void
		{
			if(!isPlaying)
				return;
			if(destinationSoundInstructionKey=="")
				destinationSoundInstructionKey=null;
			var curSoundInstruction:SoundInstruction=_soundLibraryCommands.getSoundInstruction(currentSoundInstructionKey);
			if(!curSoundInstruction)
				return;
			var destSoundInstruction:SoundInstruction=_soundLibraryCommands.getSoundInstruction(destinationSoundInstructionKey);
			var currentSoundInstructionObjects:Dictionary=new Dictionary(true);
			var destinationSoundInstructionObjects:Dictionary=new Dictionary(true);
			if(playingMusic)
			{
				currentSoundInstructionObjects = curSoundInstruction.musicInstructionObjects;
				destinationSoundInstructionObjects = destSoundInstruction.musicInstructionObjects;
				removeDissimilarAndUpdateSimilar(currentSoundInstructionObjects,destinationSoundInstructionObjects,SoundObjectType.MUSIC,false);
			}
			if(playingAmbient)
			{
				currentSoundInstructionObjects = curSoundInstruction.ambientInstructionObjects;
				destinationSoundInstructionObjects = destSoundInstruction.ambientInstructionObjects;
				removeDissimilarAndUpdateSimilar(currentSoundInstructionObjects,destinationSoundInstructionObjects,SoundObjectType.AMBIENT,false);
			}
		}
		
		public function stopAllSounds(time:Number=.3,fade:Boolean=true,callback:Function=null,removeOnComplete:Boolean=true):void
		{
			if(playingAmbient)
				fadeAmbientChannels(0,(fade)?time:0,removeOnComplete);
			if(playingMusic)
				fadeMusicChannels(0,(fade)?time:0,removeOnComplete);
			if(callback != null)
				TweenLite.delayedCall(.3,callback);
		}
		
		public function playUISound( sound:Sound, callback:Function, _name:String, ignorePreviousCallback:Boolean = false, volumeMultiplier:Number = -1 ):void
		{
			// get ui sound volume
			_uiSoundTransform.volume = (_muted) ? 0 : (volumeMultiplier != -1) ? uiSoundLevel*volumeMultiplier : uiSoundLevel;
			
			//LoggingUtils.msgTrace("Playing UI sound (vol:"+_uiSoundTransform.volume+")",LOCATION);
			//check for other sounds playing with the same name
			if ( _uiSoundChannel != null )
			{
				//stop channel
				_uiSoundChannel.stop();
				
				// reset sound signal
				_uiSoundFinished.removeAll();
				_uiSoundFinished = null;
				
				//reset channel
				_uiSoundChannel = null;
				
				//do callback if not set to ignore
				if ( !ignorePreviousCallback )
					if(_uiCallbacks[_currentUISound]!=null)
						_uiCallbacks[_currentUISound]();
				
				//reset callback at name
				if(_uiCallbacks[_name]!=null)
				{
					_uiCallbacks[_name] = null;
					delete _uiCallbacks[_name];
				}
			}
			
			//store handler in dictionary by name
			_uiCallbacks[_name] = function():void { callback(_name) };
			
			//create function to clean up and do callback
			var onFinished:Function = function ( e:Event ):void
			{
				// reset sound signal
				_uiSoundFinished.removeAll();
				_uiSoundFinished = null;
				
				//reset sound channel
				_uiSoundChannel = null;
				
				// do callback
				_uiCallbacks[_name]();
				
				//reset callback at name
				_uiCallbacks[_name] = null;
				delete _uiCallbacks[_name];
				
				_currentUISound=null;
			};
			
			_currentUISound=_name;
			
			//play sound
			_uiSoundChannel = sound.play( 0, 0, _uiSoundTransform );
			
			//create sound finished signal
			_uiSoundFinished = new NativeSignal( _uiSoundChannel, Event.SOUND_COMPLETE, Event );
			
			//add listener to sound finished signal
			_uiSoundFinished.addOnce( onFinished );
		}
		
		public function playSingleSound(key:String, sound:Sound, volume:Number = 1, callback:Function = null):void
		{
			if(singleSounds[key] != null)
			{ LoggingUtils.msgTrace("Already playing sound at key: " + key, LOCATION);	return; }
			var object:BaseSoundObject = new BaseSoundObject(sound, (_muted) ? 0 : volume);
			singleSounds[key] = object;
			singleSoundIgnoreCallback[key] = false;
			LoggingUtils.msgTrace("Play single sound (" + key +") at: "+volume,LOCATION);
			if(callback !=null)
				object.soundComplete.addOnce( 
					function():void
					{
						if(!singleSoundIgnoreCallback[key])
							callback();
					}
				);
			object.soundComplete.addOnce( function():void { clearSingleSound(key); } );
			object.playSound();
		}
		
		public function playSingleSoundObject(key:String, type:String, vol:Number = 1, callback:Function = null):void
		{
			playSingleSound(key, Sound(getSoundInstance(key,type)),vol,callback);
		}
		
		public function stopSingleSound(key:String, ignoreCallback:Boolean = true):void
		{
			if(singleSounds[key] == null)
				return;
			LoggingUtils.msgTrace("Stop single sound (" + key +")",LOCATION);
			var object:BaseSoundObject = BaseSoundObject(singleSounds[key]);
			if(object.playing)
			{
				if(ignoreCallback)
					singleSoundIgnoreCallback[key] = true;
				object.stopSound();	
			}
		}
		
		public function fadeSingleSound(key:String, to:Number, duration:Number, callback:Function = null):void
		{
			if(singleSounds[key] == null)
				return;
			var object:BaseSoundObject = BaseSoundObject(singleSounds[key]);
			singleSoundIgnoreCallback[key] = false;
			if(callback !=null)
				object.fadeComplete.addOnce( 
					function():void
					{
						if(!singleSoundIgnoreCallback[key])
							callback();
						clearSingleSound(key);
					}
				);
			
			object.fadeTo(to,duration);
		}
		
		public function destroy():void
		{
			trace("destroy OddSounds");
			if(_isPlaying) {
				trace("is playing");
				stopAllSounds();
			}
			if(_soundLibraryCommands)
				_soundLibraryCommands.destroy();
			_soundLibraryCommands=null;
			_uiSoundTransform=null;
			OddSoundInterface.destroy();
			DictionaryUtils.emptyDictionary(_uiCallbacks);
			DictionaryUtils.emptyDictionary(_musicSoundChannels);
			DictionaryUtils.emptyDictionary(_ambientSoundChannels);
			DictionaryUtils.emptyDictionary(_musicFinishedCallbacks);
			DictionaryUtils.emptyDictionary(_ambientFinishedCallbacks);
			DictionaryUtils.emptyDictionary(_musicSoundTransforms);
			DictionaryUtils.emptyDictionary(_ambientSoundTransforms);
			DictionaryUtils.emptyDictionary(_musicObjectVolumes);
			DictionaryUtils.emptyDictionary(_ambientObjectVolumes);
			DictionaryUtils.emptyDictionary(_fadeMusicTimers);
			DictionaryUtils.emptyDictionary(_fadeAmbientTimers);
			DictionaryUtils.emptyDictionary(_onFadeMusicTimer);
			DictionaryUtils.emptyDictionary(_onFadeAmbientTimer);
			DictionaryUtils.emptyDictionary(singleSounds);
			DictionaryUtils.emptyDictionary(singleSoundIgnoreCallback);
			_uiCallbacks=_musicSoundChannels=_ambientSoundChannels=_musicFinishedCallbacks=_ambientFinishedCallbacks=
				_musicSoundTransforms=_ambientSoundTransforms=_musicObjectVolumes=_musicObjectVolumes=_ambientObjectVolumes=
				_fadeMusicTimers=_fadeAmbientTimers=_onFadeMusicTimer=_onFadeAmbientTimer=singleSounds=singleSoundIgnoreCallback=null;
		}
		
		// private methods:
		private function getSoundInstance(soundObjectKey:String,type:String):Sound
		{
			var s:Sound;
			var oS:SoundObject=_soundLibraryCommands.getSoundObject(soundObjectKey,type);
			s = AssetUtils.getAssetInstance(oS.className) as Sound;
			return s;
		}
		
		private function get playingMusic():Boolean
		{
			//LoggingUtils.msgTrace(String((_numMusicSoundChannels > 0) ? true : false),LOCATION+".get playingMusic()");
			return (_numMusicSoundChannels > 0) ? true : false;
		}
		
		private function get playingAmbient():Boolean
		{
			//LoggingUtils.msgTrace(String((_numAmbientSoundChannels > 0) ? true : false),LOCATION+".get playingAmbient()");
			return (_numAmbientSoundChannels > 0) ? true : false;
		}
		
		private function get uiSoundLevel():Number
		{
			return ( OddConfig.globalVolume * OddConfig.uiVolumeOffset );
		}
		
		private function get musicSoundLevel():Number
		{
			return ( OddConfig.globalVolume * OddConfig.musicVolumeOffset );
		}
		
		private function get ambientSoundLevel():Number
		{
			return ( OddConfig.globalVolume * OddConfig.ambientVolumeOffset );
		}
		
		private function getPlayingKeys(type:String):Dictionary
		{
			var keys:Dictionary = new Dictionary(true);
			var k:Object;
			if(type==SoundObjectType.MUSIC)
			{
				if(playingMusic)
				{
					for(k in _musicSoundChannels)
					{
						keys[k] = k;
					}
				}
			} else if (type==SoundObjectType.AMBIENT)
			{
				if(playingAmbient)
				{
					for(k in _ambientSoundChannels)
					{
						keys[k] = k;
					}
				}
			}
			return keys;
		}
		
		private function removeDissimilarAndUpdateSimilar(currentSoundInstructionObjects:Dictionary,destinationSoundInstructionObjects:Dictionary,type:String,fade:Boolean=true):void
		{	
			var similar:Array = new Array();
			var dissimilar:Array = new Array();
			var i:uint;
			
			for(var key:String in currentSoundInstructionObjects)
				if (destinationSoundInstructionObjects[key])
					similar.push(key);
				else
					dissimilar.push(key);
			
			for(i=0;i<dissimilar.length;i++)
			{
				if(type==SoundObjectType.MUSIC)
				{
					if(fade)
						fadeMusicChannel(dissimilar[i],0,OddConfig.panelTransitionTime*2,true);
					else 
						removeMusicChannel(dissimilar[i]);
				} else if(type==SoundObjectType.AMBIENT)
				{
					if(fade)
						fadeAmbientChannel(dissimilar[i],0,OddConfig.panelTransitionTime*2,true);
					else 
						removeAmbientChannel(dissimilar[i]);
				}	
			}
			for(i=0;i<similar.length;i++)
			{
				var to:Number = SoundInstructionObject(destinationSoundInstructionObjects[similar[i]]).volume;
				var different:Boolean = (SoundInstructionObject(currentSoundInstructionObjects[similar[i]]).volume != to) ? true : false;
				if(different)
				{
					if(type==SoundObjectType.MUSIC)
						if(fade)
							fadeMusicChannel(similar[i],to,OddConfig.panelTransitionTime*2);
						else 
							changeSoundChannelVolume(similar[i],SoundObjectType.MUSIC,to);
						else if(type==SoundObjectType.AMBIENT)
							if(fade)
								fadeAmbientChannel(similar[i],to,OddConfig.panelTransitionTime*2);
							else 
								changeSoundChannelVolume(similar[i],SoundObjectType.AMBIENT,to);
				}
			}
			/*} */
			similar = dissimilar = null;
			currentSoundInstructionObjects = destinationSoundInstructionObjects = null;
		}
		
		/**
		 * Note: Since function does not edit sound transforms directly (passes to another function),
		 * this function will pass volume levels as is (without factoring in sound offsets)
		 * @param to
		 * @param time
		 * @param removeAllOnComplete
		 * 
		 */
		private function fadeMusicChannels(to:Number=0,time:Number=.3,removeAllOnComplete:Boolean=false):void
		{
			LoggingUtils.msgTrace("Fading all Music Channels (to:"+to+")",LOCATION);
			var tweenCallback:Function;
			if(removeAllOnComplete) {
				var removeThese:Dictionary = new Dictionary(true);
				for (var k:Object in _musicSoundChannels)
				{
					removeThese[k] = k;
				}
				musicChannelsFadedCountdown=_numMusicSoundChannels;
				tweenCallback = function():void { musicChannelsFadedCountdown--; if(musicChannelsFadedCountdown == 0) emptyMusicChannels(removeThese); };
			}
			for(var key:String in _musicSoundChannels)			
				fadeMusicChannel(key,to,time,false,tweenCallback);
		}
		
		/**
		 * Note: Since function does not edit sound transforms directly (passes to another function),
		 * this function will pass volume levels as is (without factoring in sound offsets)
		 * @param to
		 * @param time
		 * @param removeAllOnComplete
		 * 
		 */
		private function fadeAmbientChannels(to:Number=0,time:Number=.3,removeAllOnComplete:Boolean=false):void
		{
			LoggingUtils.msgTrace("Fading all Ambient Channel ("+key+") to: "+to,LOCATION);
			var tweenCallback:Function;
			if(removeAllOnComplete) {
				var removeThese:Dictionary = new Dictionary(true);
				for (var k:Object in _ambientSoundChannels)
				{
					removeThese[k] = k;
				}
				ambientChannelsFadedCountdown=_numAmbientSoundChannels;
				tweenCallback = function():void { ambientChannelsFadedCountdown--; if(ambientChannelsFadedCountdown == 0) emptyAmbientChannels(removeThese); };
			}
			for(var key:String in _ambientSoundChannels)			
				fadeAmbientChannel(key,to,time,false,tweenCallback);
		}
		
		private function fadeMusicChannel(key:String,to:Number=0,time:Number=.3,removeKeyOnComplete:Boolean=false,callback:Function=null):void
		{
			if(_musicSoundChannels[key]==null)
			{
				LoggingUtils.msgTrace("key (" + key + ") not found",LOCATION + ".fade music channel");
				if(callback!=null)
					callback();
				return;
			}
			var volume:Number = (_muted) ? 0 : to*musicSoundLevel;
			LoggingUtils.msgTrace("Fading Music Channel ("+key+") to: "+to + "(actualVolume: " + volume  + ")",LOCATION);
			var updateChannel:Function = function():void{
				if(!_musicSoundChannels||!_musicSoundTransforms||!_musicObjectVolumes)
				{
					trace("odd sounds bug: " + key);
					return;
				}
				SoundChannel(_musicSoundChannels[key]).soundTransform = SoundTransform(_musicSoundTransforms[key]);
				_musicObjectVolumes[key]=SoundChannel(_musicSoundChannels[key]).soundTransform.volume/musicSoundLevel;
			}
			if(removeKeyOnComplete || callback!=null)
			{
				var onComplete:Function = function():void
				{
					if(removeKeyOnComplete)
						removeMusicChannel(key);
					else if(callback!=null)
						callback();
				}
			} 
			TweenLite.killTweensOf(SoundTransform(_musicSoundTransforms[key]));
			if( SoundChannel(_musicSoundChannels[key]).soundTransform.volume == volume)
			{
				if(removeKeyOnComplete || callback!=null)
				{
					_fadeMusicTimers[key]=new Timer(time);
					_onFadeMusicTimer[key]=new NativeSignal(Timer(_fadeMusicTimers[key]), TimerEvent.TIMER, TimerEvent);
					NativeSignal(_onFadeMusicTimer[key]).addOnce( function(e:TimerEvent):void { onComplete(); } );
					Timer(_fadeMusicTimers[key]).start();
				}	
			} else
			{
				if(removeKeyOnComplete || callback!=null)
					TweenLite.to( SoundTransform(_musicSoundTransforms[key]), time, {volume:volume, onUpdate:updateChannel, onComplete:onComplete} );
				else
					TweenLite.to( SoundTransform(_musicSoundTransforms[key]), time, {volume:volume, onUpdate:updateChannel});
			}
		}
		
		private function fadeAmbientChannel(key:String,to:Number=0,time:Number=.3,removeKeyOnComplete:Boolean=false,callback:Function=null):void
		{
			if(_ambientSoundChannels[key]==null)
			{
				LoggingUtils.msgTrace("key (" + key + ") not found",LOCATION + ".fade ambient channel");
				if(callback!=null)
					callback();
				return;
			}
			var volume:Number = (_muted) ? 0 : to*ambientSoundLevel;
			LoggingUtils.msgTrace("Fading Ambient Channel ("+key+") to: "+to + "(actualVolume: " + volume  + ")",LOCATION);
			var updateChannel:Function = function():void 
			{
				if(!_ambientSoundChannels||!_ambientSoundTransforms||!_ambientObjectVolumes)
				{
					trace("odd sounds bug: " + key);
					return;
				}
				SoundChannel(_ambientSoundChannels[key]).soundTransform = SoundTransform(_ambientSoundTransforms[key]);
				_ambientObjectVolumes[key]=SoundChannel(_ambientSoundChannels[key]).soundTransform.volume/ambientSoundLevel;
			}
			if(removeKeyOnComplete || callback!=null)
			{
				var onComplete:Function = function():void
				{
					if(removeKeyOnComplete)
						removeAmbientChannel(key);
					else if(callback!=null)
						callback();
				}
			}
			TweenLite.killTweensOf(SoundTransform(_ambientSoundTransforms[key]));
			if( SoundChannel(_ambientSoundChannels[key]).soundTransform.volume == volume)
			{
				if(removeKeyOnComplete || callback!=null)
				{
					_fadeAmbientTimers[key]=new Timer(time);
					_onFadeAmbientTimer[key]=new NativeSignal(Timer(_fadeAmbientTimers[key]), TimerEvent.TIMER, TimerEvent);
					NativeSignal(_onFadeAmbientTimer[key]).addOnce( function(e:TimerEvent):void { onComplete(); } );
					Timer(_fadeAmbientTimers[key]).start();
				}	
			} else
			{
				if(removeKeyOnComplete || callback!=null)				
					TweenLite.to( SoundTransform(_ambientSoundTransforms[key]), time, {volume:to, onUpdate:updateChannel, onComplete:onComplete} );
				else
					TweenLite.to( SoundTransform(_ambientSoundTransforms[key]), time, {volume:to, onUpdate:updateChannel});
			}
		}
		
		private function removeMusicChannel(key:String):void
		{
			if(_musicSoundChannels[key]==null)
				return;
			//trace("remove music channel : " + key);
			_numMusicSoundChannels--;
			clearSoundGroup(_musicSoundChannels,_musicFinishedCallbacks,_musicSoundTransforms,_musicObjectVolumes,key);
		}
		
		private function removeAmbientChannel(key:String):void
		{
			if(_ambientSoundChannels[key]==null)
				return;
			_numAmbientSoundChannels--;
			clearSoundGroup(_ambientSoundChannels,_ambientFinishedCallbacks,_ambientSoundTransforms,_ambientObjectVolumes,key);
		}
		
		private function emptyMusicChannels(removeThese:Dictionary=null):void
		{
			//trace("empty music channels ");
			for(var key:String in _musicSoundChannels)
			{
				if(removeThese!=null)
				{
					if(removeThese[key]!=null) {
						clearSoundGroup(_musicSoundChannels,_musicFinishedCallbacks,_musicSoundTransforms,_musicObjectVolumes,key);
						_numMusicSoundChannels--;
					}
				}else {
					_numMusicSoundChannels=0;
					clearSoundGroup(_musicSoundChannels,_musicFinishedCallbacks,_musicSoundTransforms,_musicObjectVolumes,key);
				}
			}
		}
		
		private function emptyAmbientChannels(removeThese:Dictionary=null):void
		{
			for(var key:String in _ambientSoundChannels)
			{
				if(removeThese!=null)
				{
					if(removeThese[key]!=null) {
						clearSoundGroup(_ambientSoundChannels,_ambientFinishedCallbacks,_ambientSoundTransforms,_ambientObjectVolumes,key);
						_numAmbientSoundChannels--;
					}
				} else {
					_numAmbientSoundChannels=0;
					clearSoundGroup(_ambientSoundChannels,_ambientFinishedCallbacks,_ambientSoundTransforms,_ambientObjectVolumes,key);
				}
			}
		}
		
		private function updateSoundObjectsVolume():void
		{
			LoggingUtils.msgTrace("",LOCATION+".updateSoundObjectsVolume()");
			var i:Object;
			for( i in _musicObjectVolumes)
			{
				SoundTransform(_musicSoundTransforms[i]).volume = (_muted) ? 0 : Number(_musicObjectVolumes[i])*musicSoundLevel;
				SoundChannel(_musicSoundChannels[i]).soundTransform = SoundTransform(_musicSoundTransforms[i]);	
			}
			
			for( i in _ambientObjectVolumes)
			{
				SoundTransform(_ambientSoundTransforms[i]).volume =  (_muted) ? 0 : Number(_ambientObjectVolumes[i])*ambientSoundLevel;
				SoundChannel(_ambientSoundChannels[i]).soundTransform = SoundTransform(_ambientSoundTransforms[i]);
			}
		}
		
		private function changeSoundChannelVolume(key:String,type:String,volume:Number):void
		{
			LoggingUtils.msgTrace("",LOCATION+".changeSoundChannelVolume() " + key + " to: " + volume);
			if(type==SoundObjectType.MUSIC)
			{
				//update volume
				if(Number(_musicObjectVolumes[key])!=volume)
				{
					_musicObjectVolumes[key]=volume;
					SoundTransform(_musicSoundTransforms[key]).volume = (_muted) ? 0 : volume*musicSoundLevel;
					SoundChannel(_musicSoundChannels[key]).soundTransform = SoundTransform(_musicSoundTransforms[key]);	
				}
			}else if(type==SoundObjectType.AMBIENT)
			{
				if(Number(_ambientObjectVolumes[key])!=volume)
				{
					_ambientObjectVolumes[key]=volume;
					SoundTransform(_ambientSoundTransforms[key]).volume = (_muted) ? 0 : volume*ambientSoundLevel;
					SoundChannel(_ambientSoundChannels[key]).soundTransform = SoundTransform(_ambientSoundTransforms[key]);
				}
			}
		}
		
		private function clearSingleSound(key:String):void
		{
			if(singleSounds==null)
				return;
			if(singleSounds[key] == null)
				return;
			var object:BaseSoundObject = BaseSoundObject(singleSounds[key]);
			object.destroy()
			singleSounds[key] = null;
			delete singleSounds[key];
			delete singleSoundIgnoreCallback[key];
		}
		
		private function playSoundObject(type:String,soundGroupKey:String,soundInstructionKey:String,volume:Number=1,loop:Boolean = true,nextKey:String=null):void
		{
			LoggingUtils.msgTrace("registering sound ("+type+") Channel ("+soundGroupKey+") at: "+volume,LOCATION);
			// separate by type
			if(type == SoundObjectType.MUSIC)
			{
				//ignore play command if group playing with the same name
				if (!_musicSoundChannels[soundGroupKey])
				{
					_numMusicSoundChannels++;
					registerPlaySoundGroup(_musicSoundChannels,_musicFinishedCallbacks,_musicSoundTransforms,_musicObjectVolumes,volume,type,soundGroupKey,soundInstructionKey,loop,nextKey);
				} else {
					LoggingUtils.msgTrace("Ignoring register command, sound already playing",LOCATION);
				}
			}
			else if (type == SoundObjectType.AMBIENT)
			{
				if (!_ambientSoundChannels[soundGroupKey])
				{
					_numAmbientSoundChannels++;
					registerPlaySoundGroup(_ambientSoundChannels,_ambientFinishedCallbacks,_ambientSoundTransforms,_ambientObjectVolumes,volume,type,soundGroupKey,soundInstructionKey,loop,nextKey);
				} else {
					LoggingUtils.msgTrace("Ignoring register command, sound already playing",LOCATION);
				}
			}
		}
		
		// private methods:
		private function registerPlaySoundGroup(channelsDictionary:Dictionary, callbacksDictionary:Dictionary, transforms:Dictionary, volumesDictionary:Dictionary, volume:Number, type:String, soundObjectKey:String, soundInstructionKey:String, loop:Boolean = true, nextKey:String = null):void
		{
			//LoggingUtils.msgTrace("Registering Play Sound Group",LOCATION);
			var channel:SoundChannel = new SoundChannel();
			
			var transform:SoundTransform;
			var soundInstance:Sound;
			volumesDictionary[soundObjectKey]=volume;
			if(type==SoundObjectType.MUSIC)
			{
				transform = new SoundTransform( (_muted) ? 0 : volume*musicSoundLevel);
				LoggingUtils.msgTrace("Playing music sound ["+soundObjectKey+"] (vol:"+((_muted) ? 0 : volume*musicSoundLevel)+")",LOCATION);
			}
			else if(type==SoundObjectType.AMBIENT)
			{
				transform = new SoundTransform( (_muted) ? 0 : volume*ambientSoundLevel);
				LoggingUtils.msgTrace("Playing ambient sound ["+soundObjectKey+"] (vol:"+((_muted) ? 0 : volume*ambientSoundLevel)+")",LOCATION);
			}
			var listener:Function = function(e:Event):void
			{
				LoggingUtils.msgTrace("Sound ["+soundObjectKey+"] Complete");
				clearSoundGroup(channelsDictionary,callbacksDictionary,transforms,volumesDictionary,soundObjectKey);
				if(type==SoundObjectType.MUSIC)
					_numMusicSoundChannels--;
				else if(type==SoundObjectType.AMBIENT)
					_numAmbientSoundChannels--;
				if(nextKey)
				{
					var soundInstructionObject:SoundInstructionObject = _soundLibraryCommands.getSoundInstructionObject(soundInstructionKey,soundObjectKey,type);
					playSoundObject(type,nextKey,soundInstructionKey,soundInstructionObject.volume,soundInstructionObject.loop,soundInstructionObject.nextSoundObjectKey);
				}
			};
			
			soundInstance = getSoundInstance(soundObjectKey,type);
			if(soundInstance == null)
				return;
			channelsDictionary[soundObjectKey] = channel = soundInstance.play(0,(loop == true)?9999:0,transform);
			var soundFinished:NativeSignal = new NativeSignal(channel,Event.SOUND_COMPLETE,Event);
			soundFinished.addOnce(listener);
			callbacksDictionary[soundObjectKey] = soundFinished;
			transforms[soundObjectKey] = transform;
		}
		
		private function clearSoundGroup(channels:Dictionary,callbacks:Dictionary,transforms:Dictionary,volumes:Dictionary,key:String):void
		{
			if(callbacks[key] != null)
				NativeSignal(callbacks[key]).removeAll();
			if(channels[key] != null)
				SoundChannel(channels[key]).stop();
			channels[key]=null;
			callbacks[key]=null;
			transforms[key]=null;
			volumes[key]=null;
			if(_onFadeMusicTimer[key]!=null)
			{
				NativeSignal(_onFadeMusicTimer[key]).removeAll();
				_onFadeMusicTimer[key]=null;
				delete _onFadeMusicTimer[key];
			}
			if(_fadeMusicTimers[key]!=null)
			{
				_fadeMusicTimers[key]=null;
				delete _fadeMusicTimers[key];
			}
			if(_onFadeAmbientTimer[key]!=null)
			{
				NativeSignal(_onFadeAmbientTimer[key]).removeAll();
				_onFadeAmbientTimer[key]=null;
				delete _onFadeAmbientTimer[key];
			}
			if(_fadeAmbientTimers[key]!=null)
			{
				_fadeAmbientTimers[key]=null;
				delete _fadeAmbientTimers[key];
			}
			delete channels[key];
			delete callbacks[key];
			delete transforms[key];
			delete volumes[key];
		}
	}
}