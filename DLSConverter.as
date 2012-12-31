package  {
	
	import flash.utils.*;
	
	import Nitro.SDAT.*;
	import Nitro.SDAT.InfoRecords.*;
	
	import Chunks.*;
	import HTools.Audio.WaveWriter;
	
	import HTools.RIFF.*;
	
	public class DLSConverter {
		
		private var sdat:SDAT;
		
		private var gameTitle:String;
		
		private var riff:RIFFChunk;
		
		private var waveBankStarts:Object;
		private var waveBankList:Vector.<uint>;
		private var waves:Vector.<Wave>;
		
		public var errors:Vector.<Error>;

		public function DLSConverter(sdat:SDAT,gameTitle:String) {
			if(!sdat) throw new ArgumentError("No SDAT!");
			this.sdat=sdat;
			if(!gameTitle) throw new ArgumentError("No game title!");
			this.gameTitle=gameTitle;
			
			errors=new Vector.<Error>();
		}
		
		public function convert():ByteArray {
			
			riff=new RIFFChunk("DLS ");
			
			//set the file version
			var vers:versChunk=new versChunk();
			vers.minor=1;
			riff.subchunks.push(vers);
			
			//
			setDefaultAttributes();
			
			//build a list of all wave banks needed
			buildWaveBankList();
			//load and convert each sample in each bank in it to a wave chunk
			//also, build a table of at which sample index each bank starts
			buildWavePool();
			
			//build a list of all the instruments
			buildInstruments();
			
			return riff.writeChunk();
		}
		
		public function setDefaultAttributes():void {
			//set some metadata
			var infoChunk:INFOChunk=new INFOChunk();
			
			var attributes:Object=infoChunk.attributes;
			
			var date:Date=new Date();
			
			attributes["ISFT"] =  "Henke37's Nitro2DLS converter v 0.3",
			attributes["IMED"] =  "Nintendo composer archive";
			attributes["ICRD"] =  (date.fullYear+"-"+zeroPad(date.month+1)+"-"+zeroPad(date.date));
			attributes["IKEY"] =  "DS; Nintendo; Rip; Game; Converted";
			attributes["IPRD"] =  gameTitle;
			attributes["IGNR"] =  "game";
			
			riff.subchunks.push(infoChunk);
		}
		
		private static function zeroPad(i:uint,l:uint=2):String {
			var o:String=i.toString();
			
			while(o.length<l) {
				o="0"+o;
			}
			return o;
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
			waves=new Vector.<Wave>();
			
			var wvpl:LISTChunk=new LISTChunk("wvpl");
			
			var waveSlot:uint=0;
			for each(var id:uint in waveBankList) {
				var swar:SWAR=sdat.openSWAR(id);
				
				waveBankStarts[id]=waveSlot;
				
				for(var j:uint=0;j<swar.waves.length;++j) {
					var wave:Wave=swar.waves[j];
					var wChunk:waveChunk=convertWave(wave);
					wvpl.subchunks.push(wChunk);
					
					waves[waveSlot]=wave;
					
					++waveSlot;
				}
			}
			
			wvpl.pointerTable=new Vector.<uint>();
			wvpl.writeChunk();//precache the list since we are building a pointer table to it
			
			var ptbl:ptblChunk=new ptblChunk(wvpl.pointerTable);
			riff.subchunks.push(ptbl);
			
			riff.subchunks.push(wvpl);//I like my tables before the data for some reason
			
		}
		
		private function convertWave(w:Wave):waveChunk {
			
			var sampleSize:uint=((w.encoding==Wave.PCM8)?8:16);
			
			var encoder:WaveWriter=new WaveWriter(false,sampleSize,w.samplerate);
			var decoder:WaveDecoder=new WaveDecoder(w);
			decoder.loopAllowed=false;
			decoder.rendAsMono=true;
			
			const rendSize:uint=8000;
			var rendBuf:ByteArray=new ByteArray();
			do {
				rendBuf.length=0;
				var rendered:uint=decoder.render(rendBuf,rendSize);
				rendBuf.position=0;
				encoder.addSamples(rendBuf);
			} while(rendered==rendSize);
			
			encoder.finalize();
			
			var chunk:waveChunk=new waveChunk(encoder.outBuffer);
			
			return chunk;
		}
		
		private function buildInstruments():void {
			var lins:LISTChunk=new LISTChunk("lins");
			
			var instrumentCount:uint;
			
			for(var bankId:uint=0;bankId<sdat.bankInfo.length;++bankId) {
				
				try {
				
					var bank:SBNK=sdat.openBank(bankId);
					var bankInfo:BankInfoRecord=sdat.bankInfo[bankId];
					
					for(var instrumentId:uint=0;instrumentId<bank.instruments.length;++instrumentId) {
						
						var instrument:Instrument=bank.instruments[instrumentId];
						if(!instrument) continue;
						if(instrument.noteType!=Instrument.NOTETYPE_PCM) continue;
						
						++instrumentCount;
						
						var ins:LISTChunk=new LISTChunk("ins ");
						lins.subchunks.push(ins);
						
						var insh:inshChunk=new inshChunk(bankId,instrumentId,instrument.regions.length,instrument.drumset);
						ins.subchunks.push(insh);
						
						var lrgn:LISTChunk=new LISTChunk("lrgn");
						ins.subchunks.push(lrgn);
						
						for(var regionId:uint=0;regionId<instrument.regions.length;++regionId) {
							var region:InstrumentRegion=instrument.regions[regionId];
							
							var rgn:LISTChunk=new LISTChunk("rgn ");
							lrgn.subchunks.push(rgn);
							
							var rgnh:rgnhChunk=new rgnhChunk(region.lowEnd,region.highEnd,rgnhChunk.F_RGN_OPTION_SELFNONEXCLUSIVE);
							rgn.subchunks.push(rgnh);
							
							var archiveIndex:uint=bankInfo.swars[region.swar];
							
							var waveIndex:uint=waveBankStarts[archiveIndex]+region.swav;
							
							var wlnk:wlnkChunk=new wlnkChunk(waveIndex);
							rgn.subchunks.push(wlnk);
							
							var wave:Wave=waves[waveIndex];
							
							var loopLen:uint;
							if(wave.loops) {
								loopLen=wave.sampleCount-wave.loopStart;
							} else {
								loopLen=0;
							}
							
							var wsmp:wsmpChunk=new wsmpChunk(region.baseNote,wave.loopStart,loopLen);
							rgn.subchunks.push(wsmp);
							
							/*if(instrument.regions.length>1) {
								rgn.subchunks.push(artForRegion(region));
							}*/
						}
						
						/*
						if(instrument.regions.length==1) {
							ins.subchunks.push(artForRegion(instrument.regions[0]));
						}*/
					}
				} catch (err:Error) {
					errors.push(err);
					continue;
				}
			}
			
			var colh:colhChunk=new colhChunk(instrumentCount);
			riff.subchunks.push(colh);
			
			riff.subchunks.push(lins);//might be a good idea to put the instrument list after the instrument count
			
		}
		
		private static function artForRegion(region:InstrumentRegion):Chunk {
			var art1:art1Chunk=new art1Chunk();
			
			art1.connections.push(new art1ChunkConnection(
				art1ChunkConnection.CONN_SRC_NONE,
				art1ChunkConnection.CONN_SRC_NONE,
				art1ChunkConnection.CONN_DST_EG1_ATTACKTIME,
				region.attack)
			);
			
			art1.connections.push(new art1ChunkConnection(
				art1ChunkConnection.CONN_SRC_NONE,
				art1ChunkConnection.CONN_SRC_NONE,
				art1ChunkConnection.CONN_DST_EG1_DECAYTIME,
				region.decay)
			);
			
			art1.connections.push(new art1ChunkConnection(
				art1ChunkConnection.CONN_SRC_NONE,
				art1ChunkConnection.CONN_SRC_NONE,
				art1ChunkConnection.CONN_DST_EG1_SUSTAINLEVEL,
				region.sustain)
			);
			
			art1.connections.push(new art1ChunkConnection(
				art1ChunkConnection.CONN_SRC_NONE,
				art1ChunkConnection.CONN_SRC_NONE,
				art1ChunkConnection.CONN_DST_EG1_RELEASETIME,
				region.release)
			);
			
			art1.connections.push(new art1ChunkConnection(
				art1ChunkConnection.CONN_SRC_NONE,
				art1ChunkConnection.CONN_SRC_NONE,
				art1ChunkConnection.CONN_DST_PAN,
				region.pan)
			);
			
			var lart:LISTChunk=new LISTChunk("lart");
			lart.subchunks.push(art1);
			
			return lart;
		}

	}
	
}
