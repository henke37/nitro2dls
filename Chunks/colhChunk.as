package Chunks {

	import flash.utils.*;
	import HTools.RIFF.*;

	public class colhChunk extends Chunk {

		public var instrumentCount:uint;

		public function colhChunk(instrumentCount:uint) {
			super("colh");
			this.instrumentCount=instrumentCount;
		}
		
		protected override function writeContents(b:ByteArray):void {
			b.writeUnsignedInt(instrumentCount);
		}

	}
	
}
