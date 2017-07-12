module processador(
						input clk, 
						input rst,
						input [7:0] pINPUT,
						output [15:0] dadoMemoria, 
						output [7:0] enderecoMemoria, 
					   output [7:0] 	pOUTPUT,
						//output [7:0]	pOUTPUT1,pOUTPUT2,pOUTPUT3,pOUTPUT4,pOUTPUT5,pOUTPUT6,pOUTPUT7,pOUTPUT8,
						output SelJMP, 
						output SelDesv,
						output Wr, 
						output [1:0] selDtWr, //alterada o valor da chave para 2 bits
					   output [7:0] dadoWr,
					   output [2:0] addRegWr,
					   output [2:0] addR1, addR2,  
						output [7:0]  R1, R2, 
					   output LdOUTPUT, 
					   output [7:0] ResultULA,
						output [2:0] estado,
						output [7:0] OUT0,OUT1,OUT2,OUT3,OUT4,OUT5,OUT6,OUT7
						
						);
												
						

//wire SelJMP;
//wire SelDesv;
//wire Wr;
//wire selDtWr;
//wire [7:0] dadoWr;
//wire [2:0] addRegWr;
//wire [2:0] addR1, addR2;  
//wire [7:0]  R1, R2; 
//wire LdOUTPUT;
//wire [7:0] ResultULA;
 //wire [2:0] estado;
 
 wire [7:0] PC, PCDsv, newPC;
 wire [15:0] dado;
 wire [3:0] opcode;
 wire LdPC;
 wire [2:0] CmdULA; 
 wire [7:0] endJMP; 
 wire [7:0] endDsv;
 wire [7:0] imediato;
 wire SelRegWr;
 wire [7:0] PCmais1, PCmais1maisDesvio;
 
 assign dadoMemoria = dado;
 assign enderecoMemoria = PC;
 assign endJMP = dado[7:0];
 assign endDsv = dado[7:0];
 assign addR1 = dado[11:9];
 assign addR2 = dado[8:6];

 assign imediato = dado[7:0];
 assign opcode = dado[15:12];

 rom rom  ( .address(PC),
				.clock(clk),
				.q(dado));	
				
 somador somador1( .arg1(PC), .arg2(8'd1), .result(PCmais1));
 
 somador somador2( .arg1(PCmais1), .arg2(endDsv), .result(PCmais1maisDesvio));
				
 mux2x3 muxAddRegWr (.sel(SelRegWr), .in1(dado[5:3]), .in2(dado[11:9]), .out(addRegWr));
 
 mux2x8 muxSelDSV(.sel(SelDesv), .in1(PCmais1), .in2(PCmais1maisDesvio), .out(PCDsv));
 
 mux2x8 muxSelJMP1(.sel(SelJMP), .in1(PCDsv), .in2(endJMP), .out(newPC));
 
 //--------------------------------------------------------------------------------------------//
 
 mux3x8 muxDtWr(.sel(selDtWr), .in1(ResultULA), .in2(imediato), .in3(pINPUT), .out(dadoWr));
 //alteraçao do multiplexador, para conter mais uma entrada (pINPUT), que representa SW[7:0]
 
 //--------------------------------------------------------------------------------------------//
 
				
 ctrl ctrl( .estado(estado),
				.clk(clk), 
				.rst(rst), 
				.OP(opcode), 
				.ResultULA(ResultULA), 
				.selDtWr(selDtWr), 
				.Wr(Wr), 
				.LdPC(LdPC), 
				.SelJMP(SelJMP), 
				.SelDesv(SelDesv), 
				.CmdULA(CmdULA), 
				.LdOUTPUT(LdOUTPUT),
				.SelRegWr(SelRegWr));
				
				
 ula ula (.portA(R1), 
          .portB(R2), 
			 .op(CmdULA),   
			 .resultado(ResultULA));
			  
 bancoRegistradores bancoRegistradores(.rst(rst), 
													.clk(clk), 
													.wrEn(Wr), 
													.addR1(addR1), 
													.addR2(addR2), 
													.addWr(addRegWr), 
													.dadoR1(R1), 
													.dadoR2(R2), 
													.dadoWr(dadoWr));
  
 
registrador regPC(.load(LdPC), .rst(rst), .dadoIn(newPC), .dadoOut(PC)); 

registrador regOUTPUT(.load(LdOUTPUT), .rst(rst), .dadoIn(ResultULA), .dadoOut(pOUTPUT));


//--------------------------------------------------------------------------------------------//

//registrador regOUT1(.load(LdOUTPUT), .rst(rst), .dadoIn(OUT1), .dadoOut(pOUTPUT1));

//registrador regOUT2(.load(LdOUTPUT), .rst(rst), .dadoIn(OUT2), .dadoOut(pOUTPUT2));

//registrador regOUT3(.load(LdOUTPUT), .rst(rst), .dadoIn(OUT3), .dadoOut(pOUTPUT3));

//registrador regOUT4(.load(LdOUTPUT), .rst(rst), .dadoIn(OUT4), .dadoOut(pOUTPUT4));

//registrador regOUT5(.load(LdOUTPUT), .rst(rst), .dadoIn(OUT5), .dadoOut(pOUTPUT5));

//registrador regOUT6(.load(LdOUTPUT), .rst(rst), .dadoIn(OUT6), .dadoOut(pOUTPUT6));

//registrador regOUT7(.load(LdOUTPUT), .rst(rst), .dadoIn(OUT7), .dadoOut(pOUTPUT7));

//registrador regOUT8(.load(LdOUTPUT), .rst(rst), .dadoIn(OUT8), .dadoOut(pOUTPUT8));
 
 //--------------------------------------------------------------------------------------------//
 
 EXIT SaidaOutPut(.resultULA(ResultULA), .rDest(addRegWr), .reset(rst), .ld(LdOUTPUT), .out0(OUT0), .out1(OUT1),
 .out2(OUT2), .out3(OUT3), .out4(OUT4), .out5(OUT5), .out6(OUT6), .out7(OUT7) );
 
 //instanciaçao do modulo que redireciona os dados da instrução de output para saidas distintas
 //utilizando como resultado o resultULA e como sinal chave, o resultado do multiplexador selRegWr
 //que é o endereço destino lido da instruçao output
 
 //--------------------------------------------------------------------------------------------// 
 
endmodule
