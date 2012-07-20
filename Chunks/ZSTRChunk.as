package Chunks {
	
	import flash.utils.*;
	
	public class ZSTRChunk extends Chunk{
		
		public var value:String;

		public function ZSTRChunk(tag:String) {
			super(tag);
		}
		
		protected override function writeContents(b:ByteArray):void {
			b.writeUTFBytes(value);
			b.writeByte(0);
		}

	}
	
}
