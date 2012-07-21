package Chunks {
	
	import flash.utils.*;
	
	public class Chunk {
		
		public var tag:String;
		private static const chunkAlignment:uint=2;
		public static const headerSize:uint=8;
		
		private var cachedCopy:ByteArray;

		public function Chunk(tag:String) {
			if(!tag || tag.length!=4) throw new ArgumentError("Invalid tag!");
			this.tag=tag;
		}

		public function writeChunk():ByteArray {
			if(cachedCopy) return cachedCopy;
			
			var chunk:ByteArray=new ByteArray();
			chunk.endian=Endian.LITTLE_ENDIAN;
			
			chunk.writeUTFBytes(tag);
			chunk.length=8;
			
			chunk.position=8;
			
			writeContents(chunk);
			
			chunk.position=4;
			chunk.writeUnsignedInt(chunk.length-headerSize);
			
			chunk.position=chunk.length;
			while(chunk.length%chunkAlignment) {
				chunk.writeByte(0);
			}
			
			cachedCopy=chunk;
			
			return chunk;
		}

		protected function writeContents(b:ByteArray):void {}
	}
	
}
