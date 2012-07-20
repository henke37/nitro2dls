package Chunks {
	
	import flash.utils.*;
	
	public class LISTChunk extends Chunk {
		
		public var subchunks:Vector.<Chunk>;
		
		public var listType:String;

		public function LISTChunk(listType:String) {
			super("LIST");
			
			if(!listType || listType.length!=4) throw new ArgumentError("Invalid listType!");
			this.listType=listType;
			
			subchunks=new Vector.<Chunk>();
		}


		protected override function writeContents(b:ByteArray):void {
			b.writeUTFBytes(listType);
			for each(var chunk:Chunk in subchunks) {
				b.writeBytes(chunk.writeChunk());
			}
		}
	}
	
}
