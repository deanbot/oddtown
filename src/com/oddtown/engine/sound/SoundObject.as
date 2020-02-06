package com.oddtown.engine.sound
{
	public class SoundObject
	{
		private var _key:String;
		private var _className:String;
		public function SoundObject(key:String,className:String)
		{
			_key = key;
			_className = className;
		}
		
		public function get key():String
		{
			return _key;
		}
		
		public function get className():String
		{
			return _className;
		}
	}
}