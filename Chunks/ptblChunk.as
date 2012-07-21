package Chunks {
	
	import flash.utils.*;
	
	public class ptblChunk extends Chunk{

		private var pointerTable:Vector.<uint>;
		
		private const subheaderSize:uint=8;

		public function ptblChunk(pointerTable:Vector.<uint>) {
			super("ptbl");
			this.pointerTable=pointerTable;
		}
		
		protected override function writeContents(b:ByteArray):void {
			b.writeUnsignedInt(subheaderSize);
			b.writeUnsignedInt(pointerTable.length);
			
			for(var i:uint=0;i<pointerTable.length;++i) {
				b.writeUnsignedInt(pointerTable[i] - (Chunk.headerSize+LISTChunk.subHeaderSize) ); //
			}
		}

	}
	
}
