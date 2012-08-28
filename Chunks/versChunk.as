package Chunks {
	
	import flash.utils.*;
	import HTools.RIFF.*;
	
	public class versChunk extends Chunk {
		
		public var major:uint=1;
		public var minor:uint=0;
		public var revision:uint=0;
		public var build:uint=0;

		public function versChunk() {
			super("vers");
		}
		
		protected override function writeContents(b:ByteArray):void {
			b.writeByte(major);
			b.writeByte(minor);
			b.writeByte(revision);
			b.writeByte(build);
		}

	}
	
}
