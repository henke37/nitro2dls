package Chunks {
	
	import flash.utils.*;
	
	public class INFOChunk extends LISTChunk {
		
		public var attributes:Object;

		public function INFOChunk() {
			super("INFO");
			
			attributes={};
		}
		
		public function setDefaultAttributes(gameTitle:String):void {
			var date:Date=new Date();
			
			attributes["ISFT"] =  "Henke37's Nitro2DLS converter v 0.1",
			attributes["IMED"] =  "Nintendo composer archive";
			attributes["ICRD"] =  (date.fullYear+"-"+pad(date.month+1)+"-"+pad(date.date));
			attributes["IKEY"] =  "DS; Nintendo; Rip; Game; Converted";
			attributes["IPRD"] =  gameTitle;
			attributes["IGNR"] =  "game";
		}
		
		private function buildSubchunks():void {
			subchunks.length=0;
			for(var key:String in attributes) {
				var zChunk:ZSTRChunk=new ZSTRChunk(key);
				zChunk.value=attributes[key];
				subchunks.push(zChunk);
			}
		}
		
		public override function writeChunk():ByteArray {
			buildSubchunks();
			return super.writeChunk();
		}
		
		private static function pad(i:uint,l:uint=2):String {
			var o:String=i.toString();
			
			while(o.length<l) {
				o="0"+o;
			}
			return o;
		}

	}
	
}
