package  {
	
	import flash.utils.*;
	
	import Nitro.SDAT.*;
	import Nitro.SDAT.InfoRecords.*;
	
	import Chunks.*;
	
	public class DLSConverter {
		
		private var sdat:SDAT;
		
		private var gameTitle:String;
		
		private var riff:RIFFChunk;
		
		private var waveBankStarts:Object;
		private var waveBankList:Vector.<uint>;

		public function DLSConverter(sdat:SDAT,gameTitle:String) {
			if(!sdat) throw new ArgumentError("No SDAT!");
			this.sdat=sdat;
			if(!gameTitle) throw new ArgumentError("No game title!");
			this.gameTitle=gameTitle;
		}
		
		public function convert():ByteArray {
			
			riff=new RIFFChunk("DLS ");
			
			//set the file version
			riff.subchunks.push(new versChunk());
			
			//set some metadata
			var infoChunk:INFOChunk=new INFOChunk();
			infoChunk.setDefaultAttributes(gameTitle);
			
			
			//build a list of all wave banks needed
			buildWaveBankList();
			//load and convert each sample in each bank in it to a wave chunk
			//also, build a table of at which sample index each bank starts
			buildWavePool();
			
			//build a list of all the instruments
			
			
			return riff.writeChunk();
		}
		
		private function buildWaveBankList():void {
			var scratchList:Object={};
			
			for(var i:uint=0;i<sdat.bankInfo.length;++i) {
				var bankInfo:BankInfoRecord=sdat.bankInfo[i];
				for(var j:uint=0;j<4;++j) {
					if(bankInfo.swars[j]!=-1) {
						scratchList[ bankInfo.swars[j] ]=true;
					}
				}
			}
			
			waveBankList=new Vector.<uint>();
			for(var id in scratchList) {
				waveBankList.push(id);
			}
		}
		
		private function buildWavePool():void {
			waveBankStarts={};
			
			var wvpl:wvplChunk=new LISTChunk("wvpl");
			
			var waveSlot:uint=0;
			for each(var id:uint in waveBankList) {
				var swar:SWAR=sdat.openSWAR(id);
				
				waveBankStarts[id]=waveSlot;
				
				for(var j:uint=0;j<swar.waves.length;++j) {
					var wChunk:waveChunk=convertWave(swar.waves[j]);
					wvpl.subchunks.push(wChunk);
					++waveSlot;
				}
			}
			
			var ptbl:LISTChunk=new LISTChunk("ptbl");
			
		}
		
		private function convertWave(w:Wave):waveChunk {
			//TODO: convert the sample
			var chunk:waveChunk=new waveChunk(new ByteArray());
			//Note: should add the wsmp chunk here
			
			return chunk;
		}

	}
	
}
