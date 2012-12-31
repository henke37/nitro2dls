package  {
	
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	
	import Nitro.SDAT.*;
	import Nitro.SDAT.InfoRecords.*;
	import Nitro.FileSystem.NDS;
	import Nitro.FileSystem.AbstractFile;
	
	import flash.filesystem.*;
	
	import fl.controls.*;
	import fl.events.*;
	
	public class Nitro2DLS extends MovieClip {
		
		private var selector:File;
		
		private var nds:NDS;
		
		private var sdat:SDAT;
		
		/** @private */
		public var load_mc:Button;
		
		/** @private */
		public var save_mc:Button;
		
		/** @private */
		public var status_txt:TextField;
		
		/** @private */
		public var holder_mc:Sprite;
		
		public function Nitro2DLS() {
			load_mc.addEventListener(ComponentEvent.BUTTON_DOWN,loadClick);
			save_mc.addEventListener(ComponentEvent.BUTTON_DOWN,saveClick);
			holder_mc.visible=false;
		}
		
		private function loadClick(e:ComponentEvent):void {
			selector=new File();
			selector.addEventListener(Event.SELECT,fileSelected);
			selector.browseForOpen("Select NDS rom",[new FileFilter("NDS Roms","*.nds"),new FileFilter("SDAT archives","*.sdat")]);
		}
		
		private function fileSelected(e:Event):void {
			var ext:String=selector.extension.toLocaleLowerCase();
			
			sdat=new SDAT();
			
			try {
			
				status_txt.text="SDAT loaded.";
				save_mc.enabled=true;
				
				var data:ByteArray=openFile();
				if(ext=="nds") {
					nds=new NDS();
					nds.parse(data);
					
					var files:Vector.<AbstractFile>=nds.fileSystem.searchForFile(nds.fileSystem.rootDir,/\.(?:sdat|dsxe)$/i,true,true);
					
					if(!files.length) {
						throw new Error("No SDAT found.");
					} else {
						sdat.parse(nds.fileSystem.openFileByReference(Nitro.FileSystem.File(files[0])));
					}
					
					status_txt.appendText("\n"+nds.banner.enTitle);
					
					holder_mc.visible=true;
					holder_mc.addChild(new Bitmap(nds.banner.icon));
				} else {
					nds=null;
					sdat.parse(data);
				}
			
			} catch(err:Error) {
				status_txt.text=err.message;
				save_mc.enabled=false;
			}
		}
		
		private function openFile():ByteArray {
			var fs:FileStream=new FileStream();
			var ob:ByteArray=new ByteArray();
			
			fs.open(selector,FileMode.READ);
			fs.readBytes(ob);
			fs.close();
			
			return ob;
		}
		
		private function saveClick(e:Event):void {
			var fileName:String=selector.name;
			
			var m:Array=fileName.match(/^(.*)\.[^.]+$/);
			fileName=m[1];
			
			var gameTitle:String=(nds?nds.banner.enTitle:fileName);
			
			try {
			
				var dlsConverter:DLSConverter=new DLSConverter(sdat,gameTitle);
				var dls:ByteArray=dlsConverter.convert();
				var fr:FileReference=new FileReference();
				fr.save(dls,fileName+".dls");
				
				if(dlsConverter.errors.length>0) {
					var errStr:String="There were "+dlsConverter.errors.length+" error(s) while extracting.";
					for(var errI:uint=0;errI<dlsConverter.errors.length;++errI) {
						var err:Error=dlsConverter.errors[errI];
						errStr+="\n";
						errStr+=err.message;
						trace(err.getStackTrace());
					}
					status_txt.text=errStr;
				}
			} catch(err:Error) {
				status_txt.text=err.message;
			}
		}
	}
	
}
