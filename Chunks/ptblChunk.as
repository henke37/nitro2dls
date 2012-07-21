package Chunks {
	
	import flash.utils.*;
	
	public class ptblChunk extends Chunk{

		private var pointerTable:Vector.<uint>;

		public function ptblChunk(pointerTable:Vector.<uint>) {
			super("ptbl");
			this.pointerTable=pointerTable;
		}
		
		protected override function writeContents(b:ByteArray):void {
			b.writeUnsignedInt(8);
			b.writeUnsignedInt(pointerTable.length);
			
			for(var i:uint=0;i<pointerTable.length;++i) {
				b.writeUnsignedInt(pointerTable[i]-Chunk.headerSize);
			}
		}

	}
	
}
