package  {
	
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	
	import Nitro.SDAT.*;
	import Nitro.SDAT.InfoRecords.*;
	import Nitro.FileSystem.NDS;
	
	public class Nitro2DLS extends MovieClip {
		
		private var loader:URLLoader;
		
		private var nds:NDS;
		
		private var sdat:SDAT;
		
		public function Nitro2DLS() {
			loader=new URLLoader();
			loader.dataFormat=URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE,loaded);
			loader.load(new URLRequest("aj.nds"));
		}
		
		private function loaded(e:Event):void {
			nds=new NDS();
			nds.parse(loader.data);
			
			sdat=new SDAT();
			sdat.parse(nds.fileSystem.openFileByName("sound_data.sdat"));
			
			var dlsConverter:DLSConverter=new DLSConverter(sdat,nds.banner.enTitle);
			
			var fr:FileReference=new FileReference();
			fr.save(dlsConverter.convert(),"aj.dls");
		}
	}
	
}
