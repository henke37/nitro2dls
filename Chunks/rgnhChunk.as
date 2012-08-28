package Chunks {
	
	import flash.utils.*;
	import HTools.RIFF.*;
	
	public class rgnhChunk extends Chunk {
		
		private var lowKey:uint;
		private var highKey:uint;
		
		private var flags:uint;
		
		private var keyGroup:uint;
		
		public static const F_RGN_OPTION_SELFNONEXCLUSIVE:uint=1;

		public function rgnhChunk(lowKey:uint,highKey:uint,flags:uint=0,keyGroup:uint=0) {
			super("rgnh");
			if(lowKey>highKey) throw new RangeError("Low key can't be higher than high key!");
			this.lowKey=lowKey;
			this.highKey=highKey;
			
			this.flags=flags;
			
			this.keyGroup=keyGroup;
		}
		
		protected override function writeContents(b:ByteArray):void {
			b.writeShort(lowKey);
			b.writeShort(highKey);
			
			//velocity range, always everything in DLS1
			b.writeShort(0);
			b.writeShort(127);
			
			b.writeShort(flags);
			b.writeShort(keyGroup);
		}

	}
	
}
