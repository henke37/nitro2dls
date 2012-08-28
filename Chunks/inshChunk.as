package Chunks {
	
	import flash.utils.*;
	import HTools.RIFF.*;
	
	public class inshChunk extends Chunk {
		
		private var bankId:uint;
		private var instrumentId:uint;
		
		private var regionCount:uint;
		
		private var drumkit:Boolean;
		
		private static const F_INSTRUMENT_DRUMS:uint=0x80000000;

		public function inshChunk(bankId:uint,instrumentId:uint,regionCount:uint,drumkit:Boolean=false) {
			super("insh");
			this.bankId=bankId;
			this.instrumentId=instrumentId;
			
			this.regionCount=regionCount;
			
			this.drumkit=drumkit;
		}

		protected override function writeContents(b:ByteArray):void {
			b.writeUnsignedInt(regionCount);
			b.writeUnsignedInt(bankId | (drumkit?F_INSTRUMENT_DRUMS:0) );
			b.writeUnsignedInt(instrumentId);
		}
	}
	
}
