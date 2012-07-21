package Chunks {

	import flash.utils.*;

	public class wlnkChunk extends Chunk {
		
		public var tableIndex:uint;
		public var flags:uint;
		public var phaseGroup:uint;
		public var channel:uint=1;
		
		public static const F_WAVELINK_PHASE_MASTER:uint=0;

		public function wlnkChunk(tableIndex:uint,flags:uint=0) {
			super("wlnk");
			this.tableIndex=tableIndex;
			this.flags=flags;
		}
		
		protected override function writeContents(b:ByteArray):void {
			b.writeShort(flags);
			b.writeShort(phaseGroup);
			b.writeUnsignedInt(channel);
			b.writeUnsignedInt(tableIndex);
		}

	}
	
}
