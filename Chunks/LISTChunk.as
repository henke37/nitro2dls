package Chunks {
	
	import flash.utils.*;
	
	public class LISTChunk extends Chunk {
		
		public var subchunks:Vector.<Chunk>;
		
		public var listType:String;
		
		public var pointerTable:Vector.<uint>;
		
		public static const subHeaderSize:uint=4;

		public function LISTChunk(listType:String) {
			super("LIST");
			
			if(!listType || listType.length!=4) throw new ArgumentError("Invalid listType!");
			this.listType=listType;
			
			subchunks=new Vector.<Chunk>();
		}


		protected override function writeContents(b:ByteArray):void {
			b.writeUTFBytes(listType);
			
			if(pointerTable) {
				pointerTable.length=subchunks.length;
				pointerTable.fixed=true;
			}
			
			for(var i:uint=0;i<subchunks.length;++i) {
				var chunk:Chunk=subchunks[i];
				
				if(pointerTable) {
					pointerTable[i]=b.position;
				}
				b.writeBytes(chunk.writeChunk());
				
				if(listType=="DLS ") {
					if(chunk is LISTChunk) {
						trace(chunk.writeChunk().length,b.position,chunk.tag,LISTChunk(chunk).listType);
					} else {
						trace(chunk.writeChunk().length,b.position,chunk.tag);
					}
				}
			}
		}
	}
	
}
