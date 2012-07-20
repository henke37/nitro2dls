package Chunks {
	
	import flash.utils.*;
	
	public class wsmpChunk extends Chunk {
		
		public var unityNote:uint=60;
		public var fineTune:int=0;
		public var attuneation:uint;
		public var flags:uint;
		
		public static const F_WSMP_NO_TRUNCATION:uint=0;
		public static const F_WSMP_NO_COMPRESSION:uint=0;

		public function wsmpChunk() {
			super("wsmp");
		}

	}
	
}
