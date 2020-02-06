
package com.oddtown.engine
{	
	import com.deanverleger.core.IDestroyable;
	
	import org.casalib.events.LoadEvent;
	import org.casalib.load.DataLoad;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	public class OddLibrary implements IDestroyable
	{
		// constants:
		public static const ID:String="OddLibrary";
		
		// private properties:
		private var dataLoad:DataLoad;
		private var loadComplete:NativeSignal;
		private var _parseComplete:Signal;
		private var _xml:XML;
		
		
		// public properties:
		// constructor:
		// public getter/setters:
		public function get parseComplete():Signal
		{
			return _parseComplete;
		}
		
		// public methods:
		public function OddLibrary(xmlPath:String)
		{
//			dataLoad = new DataLoad(xmlPath);
//			loadComplete=new NativeSignal(dataLoad, LoadEvent.COMPLETE,LoadEvent);
//			loadComplete.addOnce(onXMLLoaded);
			
			
			//ID, pages, sounds
			_parseComplete=new Signal(String, XMLList, XMLList);
		}
		
		public function build():void
		{
//			dataLoad.start();
			_xml= 
				<comic>
					<sounds>
						<soundInstructions>
							<soundInstruction key="overall">
								<music soundObjectKey="overall" volume=".3" loop="true"/>
							</soundInstruction>
							<soundInstruction key="clockOutside">
								<music soundObjectKey="overall" volume=".5" loop="true"/>
								<ambient soundObjectKey="clockLoop" volume=".4" loop="true"/>
							</soundInstruction>
							<soundInstruction key="clockInside">
								<music soundObjectKey="overall" volume=".3" loop="true"/>
								<ambient soundObjectKey="clockLoop" volume=".5" loop="true"/>
							</soundInstruction>
							<soundInstruction key="clockLoud">
								<music soundObjectKey="overall" volume=".3" loop="true"/>
								<ambient soundObjectKey="clockLoop" volume=".7" loop="true"/>
							</soundInstruction>
							<soundInstruction key="paperFlutter">
								<music soundObjectKey="overall" volume=".3" loop="true"/>
								<ambient soundObjectKey="paperFlutter" volume="1" />
							</soundInstruction>
							<soundInstruction key="handSlam">
								<music soundObjectKey="overall" volume=".3" loop="true"/>
								<ambient soundObjectKey="handSlam" volume="1" />
							</soundInstruction>
							<soundInstruction key="sigh">
								<music soundObjectKey="overall" volume=".3" loop="true"/>
								<ambient soundObjectKey="sigh" volume=".8" />
							</soundInstruction>
							<soundInstruction key="slidePaper">
								<music soundObjectKey="overall" volume=".3" loop="true"/>
								<ambient soundObjectKey="slidePaper" volume=".8" />
							</soundInstruction>
							<soundInstruction key="stainedGlass">
								<music soundObjectKey="stainedGlass" volume="1" loop="true"/>	
							</soundInstruction>
							<soundInstruction key="glassBreak">				
								<music soundObjectKey="stainedGlass" volume="1" loop="true"/>	
								<ambient soundObjectKey="glassBreak" volume=".5"/>	
							</soundInstruction>
							<soundInstruction key="glassFall">				
								<music soundObjectKey="overall" volume=".3" loop="true"/>	
								<ambient soundObjectKey="glassFall" volume=".5"/>	
							</soundInstruction>
							<soundInstruction key="cactusFall">
								<music soundObjectKey="cactusFall" volume=".5" loop="true"/>	
							</soundInstruction>
							<soundInstruction key="cactusFail">
								<music soundObjectKey="cactusFail" volume="1" loop="true"/>	
							</soundInstruction>
							<soundInstruction key="gusGoesOut">
								<music soundObjectKey="gusGoesOut" volume=".3" loop="true"/>	
							</soundInstruction>
							<soundInstruction key="credits">
								<music soundObjectKey="credits" volume="1" loop="true"/>	
							</soundInstruction>
						</soundInstructions>
						<soundObjects>
							<music>
								<soundObject key="overall" className="MU_Overall"/>
								<soundObject key="stainedGlass" className="MU_StainedGlass"/>
								<soundObject key="cactusFall" className="MU_CactusFall"/>
								<soundObject key="cactusFail" className="MU_CactusFail"/>
								<soundObject key="gusGoesOut" className="MU_GusGoesOut"/>
								<soundObject key="credits" className="MU_Credits"/>
							</music>
							<ambient>
								<soundObject key="clockLoop" className="AM_Clock"/>
								<soundObject key="writing" className="AM_Writing"/>
								<soundObject key="paperFlutter" className="AM_PaperFlutter"/>
								<soundObject key="handSlam" className="AM_HandSlam"/>
								<soundObject key="sigh" className="AM_Sigh"/>
								<soundObject key="slidePaper" className="AM_SlidingPaper"/>
								<soundObject key="glassBreak" className="AM_GlassBreak"/>
								<soundObject key="glassFall" className="AM_GlassFall"/>
							</ambient>
						</soundObjects>
					</sounds>
					<pages firstPage="1">
						<page order="1" className="Pg1" nextPage="2" soundInstructionKey="overall">
							<panel order="1" pageX="0" pageY="0"></panel>
							<panel order="2" pageX="0" pageY="-488" soundInstructionKey="clockOutside"></panel>
							<panel order="3" pageX="0" pageY="-488" soundInstructionKey="clockOutside"></panel>
							<panel order="4" pageX="0" pageY="-818" soundInstructionKey="clockInside"></panel>	
						</page>
						<page order="2" className="Pg2" nextPage="3" soundInstructionKey="overall">
							<panel order="1" pageX="0" pageY="0" soundInstructionKey="paperFlutter"></panel>
							<panel order="2" pageX="0" pageY="-376"></panel>
							<panel order="3" pageX="0" pageY="-376"></panel>
							<panel order="4" pageX="0" pageY="-818" soundInstructionKey="handSlam"></panel>
							<panel order="5" pageX="0" pageY="-818"></panel>	
						</page>
						<page order="3" className="Pg3" nextPage="4" soundInstructionKey="overall">
							<panel order="1" pageX="0" pageY="0" soundInstructionKey="sigh"></panel>
							<panel order="2" pageX="0" pageY="0" delay="4"></panel>
							<panel order="3" pageX="0" pageY="-376"></panel>
							<panel order="4" pageX="0" pageY="-818"></panel>
							<panel order="5" pageX="0" pageY="-818"></panel>	
						</page>
						<page order="4" className="Pg4" nextPage="5" soundInstructionKey="overall">
							<panel order="1" pageX="0" pageY="40"></panel>
							<panel order="2" pageX="0" pageY="-376"></panel>
							<panel order="3" pageX="0" pageY="-376"></panel>
							<panel order="4" pageX="0" pageY="-376"></panel>
							<panel order="5" pageX="0" pageY="-818"></panel>	
						</page>
						<page order="5" className="Pg5" nextPage="6" soundInstructionKey="overall">
							<panel order="1" pageX="0" pageY="0"></panel>
							<panel order="2" pageX="0" pageY="0"></panel>
							<panel order="3" pageX="0" pageY="-376"></panel>
							<panel order="4" pageX="0" pageY="-376"></panel>
							<panel order="5" pageX="0" pageY="-818" soundInstructionKey="slidePaper"></panel>
							<panel order="6" pageX="0" pageY="-818"></panel>	
						</page>
						<page order="6" className="Pg6" nextPage="7" soundInstructionKey="overall">
							<panel order="1" pageX="0" pageY="0"></panel>
							<panel order="2" pageX="0" pageY="-376"></panel>
							<panel order="3" pageX="0" pageY="-818"></panel>
						</page>
						<page order="7" className="Pg7" nextPage="8" soundInstructionKey="stainedGlass">
							<panel order="1" pageX="0" pageY="0" impClass="Imp_Pg7_Pan1" autoProgress="false"></panel>
						</page>
						<page order="8" className="Pg8" nextPage="9" soundInstructionKey="stainedGlass">
							<panel order="1" pageX="0" pageY="0"></panel>
							<panel order="2" pageX="0" pageY="-700"></panel>
							<panel order="3" pageX="0" pageY="-818"></panel>
						</page>
						<page order="9" className="Pg9" nextPage="10" soundInstructionKey="overall">
							<panel order="1" pageX="0" pageY="0" soundInstructionKey="glassFall"></panel>
							<panel order="2" pageX="0" pageY="0"></panel>
							<panel order="3" pageX="0" pageY="0"></panel>
							<panel order="4" pageX="0" pageY="-428"></panel>
							<panel order="5" pageX="0" pageY="-428"></panel>
							<panel order="6" pageX="0" pageY="-818"></panel>	
						</page>		
						<page order="10" className="Pg10" nextPage="11" soundInstructionKey="overall">
							<panel order="1" pageX="0" pageY="0"></panel>
							<panel order="2" pageX="0" pageY="0"></panel>
							<panel order="3" pageX="0" pageY="-610"></panel>
							<panel order="4" pageX="0" pageY="-818"></panel>
						</page>
						<page order="11" className="Pg11" nextPage="12" soundInstructionKey="overall">
							<panel order="1" pageX="0" pageY="0"></panel>
							<panel order="2" pageX="0" pageY="0"></panel>
							<panel order="3" pageX="0" pageY="0"></panel>
							<panel order="4" pageX="0" pageY="-376"></panel>
							<panel order="5" pageX="0" pageY="-818"></panel>
						</page>
						<page order="12" className="Pg12" nextPage="13" soundInstructionKey="overall">
							<panel order="1" pageX="0" pageY="0"></panel>
							<panel order="2" pageX="0" pageY="0"></panel>
							<panel order="3" pageX="0" pageY="-200"></panel>
							<panel order="4" pageX="0" pageY="-650"></panel>
							<panel order="5" pageX="0" pageY="-818"></panel>
						</page>
						<page order="13" className="Pg13" nextPage="14" soundInstructionKey="overall">
							<panel order="1" pageX="0" pageY="0"></panel>
							<panel order="2" pageX="0" pageY="0"></panel>
							<panel order="3" pageX="0" pageY="0"></panel>
							<panel order="4" pageX="0" pageY="-376"></panel>
							<panel order="5" pageX="0" pageY="-818"></panel>
							<panel order="6" pageX="0" pageY="-818" impClass="Imp_Pg13_Pan6" autoProgress="false" soundInstructionKey="clockInside"></panel>
						</page>
						<page order="14" className="Pg14" nextPage="15" soundInstructionKey="overall">
							<panel order="1" pageX="0" pageY="0"></panel>
							<panel order="2" pageX="0" pageY="0"></panel>
							<panel order="3" pageX="0" pageY="-356"></panel>
							<panel order="4" pageX="0" pageY="-818"></panel>
							<panel order="5" pageX="0" pageY="-818"></panel>
						</page>
						<page order="15" className="Pg15" nextPage="16" soundInstructionKey="overall">
							<panel order="1" autoProgress="false" impClass="Imp_Pg15_Pan1" pageX="0" pageY="0"/>
						</page>
						<page order="16" className="Pg16" nextPage="17" soundInstructionKey="overall">
							<panel order="1" autoProgress="false" impClass="Imp_Pg16_Pan1" pageX="0" pageY="0" />
							<panel order="2" delay="1.5" pageX="0" pageY="-163.85" />
							<panel order="3" autoProgress="false" impClass="Imp_Pg16_Pan3" next="1" pageX="0" pageY="-296"/>
							<panel order="4" delay="1.5" pageX="0" pageY="-163.85"/>
							<panel order="5" autoProgress="false" impClass="Imp_Pg16_Pan5" next="1" pageX="0" pageY="-296"/>
							<panel order="6" delay="1.75" pageX="0" pageY="-818"/>
						</page>
						<page order="17" className="Pg17" nextPage="18" soundInstructionKey="overall">
							<panel order="1" autoProgress="false" impClass="Imp_Pg17_Pan1" pageX="0" pageY="0"/>
							<panel order="2" autoProgress="false" impClass="Imp_Pg17_Pan2" pageX="0" pageY="-265"/>
							<panel order="3" pageX="0" pageY="-812"/>
							<panel order="4" pageX="0" pageY="-812"/>
						</page>
						<page order="18" className="Pg18" nextPage="19" soundInstructionKey="overall">
							<panel order="1" pageX="0" pageY="0"></panel>
							<panel order="2" pageX="0" pageY="-475"></panel>
							<panel order="3" pageX="0" pageY="0"></panel>
							<panel order="4" pageX="0" pageY="-475"></panel>
							<panel order="5" pageX="0" pageY="-818"></panel>
						</page>
						<page order="19" className="Pg19" nextPage="20" soundInstructionKey="overall">
							<panel order="1" impClass="Imp_Pg19_Pan1" autoProgress="false" pageX="0" pageY="0" soundInstructionKey="cactusFall"></panel>
							<panel order="2" tree="pass" pageX="0" pageY="-471"></panel>
							<panel order="2" tree="fail" pageX="0" pageY="-471" soundInstructionKey="cactusFail"></panel>
							<panel order="3" tree="pass" pageX="0" pageY="-567" delay="1"></panel>
							<panel order="3" tree="fail" pageX="0" pageY="-819" soundInstructionKey="cactusFail"></panel>
							<panel order="4" tree="pass" pageX="0" pageY="-819"></panel>  
							<panel order="4" tree="fail" pageX="0" pageY="-819" soundInstructionKey="cactusFail"></panel>
						</page>
						<page order="20" className="Pg20" nextPage="21" soundInstructionKey="overall">
							<panel order="1" pageX="0" pageY="0"/>
							<panel order="2" pageX="0" pageY="-91" impClass="Imp_Pg20_Pan2" autoProgress="false"/>
							<panel order="3" delay="2" pageX="0" pageY="-554" impClass="Imp_Pg20_Pan3" autoProgress="false" next="2"/>
							<panel order="4" pageX="0" pageY="-858" impClass="Imp_Pg20_Pan4" autoProgress="false" next="2"/>
							<panel order="5" pageX="0" pageY="-821" impClass="Imp_Pg20_Pan5" autoProgress="false"/>
						</page>
						<page order="21" className="Pg21" nextPage="22" soundInstructionKey="clockInside">
							<panel order="1" autoProgress="false" impClass="Imp_Pg21_Pan1" pageX="0" pageY="0"/>
							<panel order="2" next="1" delay="2" pageX="0" pageY="-812" soundInstructionKey="clockLoud"/>
							<panel order="3" autoProgress="false" impClass="Imp_Pg21_Pan3" pageX="0" pageY="-812"/>
						</page>
						<page order="22" className="Pg22" nextPage="23" soundInstructionKey="overall">
							<panel order="1" pageX="0" pageY="0"></panel>
							<panel order="2" pageX="0" pageY="0"></panel>
							<panel order="3" pageX="0" pageY="-350"></panel>
							<panel order="4" pageX="0" pageY="-818"></panel>
							<panel order="5" pageX="0" pageY="-818"></panel>
							<panel order="6" pageX="0" pageY="-818"></panel>
						</page>
						<page order="23" className="Pg23" nextPage="25" soundInstructionKey="gusGoesOut">
							<panel order="1" pageX="0" pageY="0" impClass="Imp_Pg23_Pan1" autoProgress="false" ></panel>
						</page>
						<page order="24" className="Pg24" nextPage="20">
							<panel order="1" />
						</page>
						<page order="25" className="FinalCredits" endPage="true" soundInstructionKey="credits">
							<panel order="1" pageX="0" pageY="0"></panel>
						</page>
					</pages>
				</comic>;
			onXMLLoaded();
		}
		
		public function destroy():void
		{
			/*if(dataLoad.loading)
				dataLoad.stop();
			dataLoad.destroy();
			dataLoad=null;
			loadComplete.remove(onXMLLoaded);
			loadComplete=null;*/
			_parseComplete.removeAll();
			_parseComplete=null;
		}
		
		// private methods:
		private function onXMLLoaded(/*e:LoadEvent*/):void 
		{
			// check for pages and sounds
			var pages:XMLList=_xml.pages;
			var sounds:XMLList=_xml.sounds;
			_parseComplete.dispatch(ID,pages,sounds);
		}
		
	}
}