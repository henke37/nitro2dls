package Chunks {
	import flash.utils.*;
	
	public class waveChunk extends Chunk {
		
		private var waveFile:ByteArray;

		public function waveChunk(waveFile:ByteArray) {
			super("wave");
			if(!waveFile) throw new ArgumentError("No wavefile!");
			this.waveFile=waveFile;
		}
		
		public override function writeChunk():ByteArray {
			
			waveFile.position=0;
			waveFile.writeUTFBytes("LIST");
			
			waveFile.position=8;
			waveFile.writeUTFBytes("wave");
			
			waveFile.position=0;
			
			return waveFile;
		}

	}
	
}
