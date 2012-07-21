package Chunks {
	
	import flash.utils.*;
	
	public class inshChunk extends Chunk {
		
		private var bankId:uint;
		private var instrumentId:uint;
		
		private var regionCount:uint;
		
		private var drumkit:Boolean;

		public function inshChunk(bankId:uint,instrumentId:uint,regionCount:uint,drumkit:Boolean=false) {
			super("insh");
			this.bankId=bankId;
			this.instrumentId=instrumentId;
			
			this.regionCount=regionCount;
			
			this.drumkit=drumkit;
		}

		protected override function writeContents(b:ByteArray):void {
			b.writeUnsignedInt(regionCount);
			b.writeUnsignedInt(bankId);
			b.writeUnsignedInt(instrumentId | (drumkit?0x80:0) );
		}
	}
	
}
