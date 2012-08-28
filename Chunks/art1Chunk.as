package Chunks {
	
	import flash.utils.*;
	import HTools.RIFF.*;
	
	public class art1Chunk extends Chunk {
		
		private var subHeaderSize:uint=8;
		
		public var connections:Vector.<art1ChunkConnection>;

		public function art1Chunk() {
			super("art1");
			connections=new Vector.<art1ChunkConnection>();
		}
		
		protected override function writeContents(b:ByteArray):void {
			b.writeUnsignedInt(subHeaderSize);
			b.writeUnsignedInt(connections.length);
			
			for each(var connection:art1ChunkConnection in connections) {
				b.writeShort(connection.source);
				b.writeShort(connection.control);
				b.writeShort(connection.destination);
				b.writeShort(connection.transform);
				b.writeInt(connection.scale);
			}
		}

	}
	
}
