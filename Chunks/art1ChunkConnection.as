package Chunks {
	
	public class art1ChunkConnection {
		
		public var source:uint;
		public var control:uint;
		public var destination:uint;
		
		public var transform:uint;
		
		public var scale:int;
		
		public static const CONN_SRC_NONE:uint=0x0000;
		public static const CONN_SRC_LFO:uint=0x0001;
		public static const CONN_SRC_KEYONVELOCITY:uint=0x0002;
		public static const CONN_SRC_KEYNUMBER:uint=0x0003;
		public static const CONN_SRC_EG1:uint=0x0004;
		public static const CONN_SRC_EG2:uint=0x0005;
		public static const CONN_SRC_PITCHWHEEL:uint=0x0006;
		
		public static const CONN_SRC_CC1:uint=0x0081;
		public static const CONN_SRC_CC7:uint=0x0087;
		public static const CONN_SRC_CC10:uint=0x008a;
		public static const CONN_SRC_CC11:uint=0x008b;
		public static const CONN_SRC_RPN0:uint=0x0100;
		public static const CONN_SRC_RPN1:uint=0x0101;
		public static const CONN_SRC_RPN2:uint=0x0102;
		
		public static const CONN_DST_NONE:uint=0x0000;
		public static const CONN_DST_ATTENUATION:uint=0x0001;
		public static const CONN_DST_PAN:uint=0x0004;
		public static const CONN_DST_PITCH:uint=0x0003;
		
		public static const CONN_DST_LFO_FREQUENCY:uint=0x0104;
		public static const CONN_DST_LFO_STARTDELAY:uint=0x0105;
		
		public static const CONN_DST_EG1_ATTACKTIME:uint=0x0206;
		public static const CONN_DST_EG1_DECAYTIME:uint=0x0207;
		public static const CONN_DST_EG1_SUSTAINLEVEL:uint=0x020a;
		public static const CONN_DST_EG1_RELEASETIME:uint=0x0209;
		
		public static const CONN_DST_EG2_ATTACKTIME:uint=0x030a;
		public static const CONN_DST_EG2_DECAYTIME:uint=0x030b;
		public static const CONN_DST_EG2_SUSTAINLEVEL:uint=0x030e;
		public static const CONN_DST_EG2_RELEASETIME:uint=0x030d;
		
		public static const CONN_TRN_NONE:uint=0x0000;
		public static const CONN_TRN_CONCAVE:uint=0x0001;

		public function art1ChunkConnection(src:uint,ctrl:uint,dst:uint,scl:int,trn:uint=0) {
			source=src;
			control=ctrl;
			destination=dst;
			scale=scl;
			transform=trn;
		}

	}
	
}
