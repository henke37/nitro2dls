package Chunks {
	
	import flash.utils.*;
	import HTools.RIFF.*;
	
	public class wsmpChunk extends Chunk {
		
		public var unityNote:uint=60;
		public var fineTune:int=0;
		public var attuneation:int;
		public var flags:uint;
		
		public static const F_WSMP_NO_TRUNCATION:uint=0x0001;
		public static const F_WSMP_NO_COMPRESSION:uint=0x0002;
		
		public var loopType:uint=0;
		public var loopStart:uint;
		public var loopLength:uint;
		
		public static const WLOOP_TYPE_FORWARD:uint=1;

		public function wsmpChunk(unityNote:uint,loopStart:uint=0,loopLength:uint=0) {
			super("wsmp");
			
			this.unityNote=unityNote;
			
			if(loopLength>0) {
				this.loopType=WLOOP_TYPE_FORWARD
				this.loopStart=loopStart;
				this.loopLength=loopLength;
			}
		}
		
		protected override function writeContents(b:ByteArray):void {
			b.writeUnsignedInt(4+2+2+4+4+4);
			b.writeShort(unityNote);
			b.writeShort(fineTune);
			b.writeInt(attuneation);
			b.writeUnsignedInt(flags);
			b.writeUnsignedInt(loopType);//really the count of loopdata entries, but that is always zero or one
			
			if(loopType==1) {
				b.writeUnsignedInt(4*4);
				b.writeUnsignedInt(loopType);
				b.writeUnsignedInt(loopStart);
				b.writeUnsignedInt(loopLength);
			}
		}

	}
	
}
