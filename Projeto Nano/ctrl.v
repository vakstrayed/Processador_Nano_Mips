 
module ctrl ( 	estado, 
					clk, 
					rst, 
					OP, 
					ResultULA, 
					selDtWr, 
					Wr, 
					LdPC, 
					SelJMP, 
					SelDesv, 
					CmdULA, 
					LdOUTPUT,
					SelRegWr
					);
  input clk, rst;
  input [3:0] OP;
  input [7:0] ResultULA;
  output reg SelRegWr;
  output reg Wr, LdPC, SelJMP, SelDesv, LdOUTPUT;
  output reg [1:0] selDtWr;         //alterada o valor da chave para 2 bits
  output reg [2:0] CmdULA; 
  output reg [2:0] estado;
  
// opcode das instruções					
  localparam opNOP  =4'h0, 
				opADD  =4'h1,
				opAND  =4'h2,
				opOR   =4'h3,
				opSUB  =4'h4,
				opNEG	 =4'h5,
				opNOT  =4'h6,
				opCPY  =4'h7,
				opLRG  =4'h8, 
				opBLT  =4'h9, 
				opBGT  =4'hA, 
				opBEQ  =4'hB, 
				opBNE  =4'hC, 
				opJMP  =4'hD, 
				opINPUT=4'hE,
				opOUTPUT=4'hF;


  // comandos para a ULA				
  localparam cmdTSTR1 =3'd0, 
				cmdADD   =3'd1,
				cmdAND   =3'd2,
				cmdOR    =3'd3,
				cmdSUB   =3'd4,
				cmdNEG   =3'd5,
				cmdNOT   =3'd6;		
  
  always @ (posedge clk or negedge rst) begin
		if (rst==0) begin // reseta todos os sinais de controle
		   estado = 3'd0;
		   selDtWr <= 2'b00; 
		   Wr <= 1'b0;
		   LdPC <= 1'b0;
			SelJMP <= 1'b0;
			SelDesv <= 1'b0;
			CmdULA <= cmdTSTR1;
			estado <= 3'd1;
			SelRegWr <= 1'b0;	
		end 
		else begin
		  case (estado)
		    0: begin // reseta todos os sinais de controle para proceder a carga de uma nova instrução
					selDtWr <= 1'b0; 
					Wr <= 1'b0;
					LdPC <= 1'b0;
					SelJMP <= 1'b0;
					SelDesv <= 1'b0;
					CmdULA <= cmdTSTR1;
					estado <= 3'd1;
					LdOUTPUT <= 1'b0;
					SelRegWr <= 1'b0;
				 end 	
			 1: estado <= 3'd2; // aguarda a leitura da instrução na memória
			 2: begin           // decodifica a instrução e programa o caminho de dados
			      case (OP)
					  opNOP:begin end     // não executa nada
					  opADD:begin	 
								  CmdULA <= cmdADD; // envia comando para ula efetuar operaçao add
								  SelRegWr <= 1'b0; // multiplexador libera o canal para o endereço de escrita
								  selDtWr <= 2'b00; // multiplexador libera o canal para o dado do resultado ula para o banco
								  Wr <= 1'b1;       // envia sinal ativo para escrever no banco registrador
							   end
					  opAND:begin
								  CmdULA <= cmdAND; // envia comando para ula efetuar operaçao and
								  SelRegWr <= 1'b0; // multiplexador libera o canal para o endereço de escrita
								  selDtWr <= 2'b00;  // multiplexador libera o canal para o dado do resultado ula para o banco
								  Wr <= 1'b1;       // envia sinal ativo para escrever no banco registrador
							  end
					  opOR:begin
								  CmdULA <= cmdOR;  // envia comando para ula efetuar operaçao or
								  SelRegWr <= 1'b0; // multiplexador libera o canal para o endereço de escrita
								  selDtWr <= 2'b00;  // multiplexador libera o canal para o dado do resultado ula para o banco
								  Wr <= 1'b1;       // envia sinal ativo para escrever no banco registrador
					       end
					  opSUB:begin
								  CmdULA <= cmdSUB; // envia comando para ula efetuar operaçao sub
								  SelRegWr <= 1'b0; // multiplexador libera o canal para o endereço de escrita
								  selDtWr <= 2'b00;  // multiplexador libera o canal para o dado do resultado ula para o banco
								  Wr <= 1'b1;       // envia sinal ativo para escrever no banco registrador
							  end
					  opNEG:begin
								  CmdULA <= cmdNEG; // envia comando para ula efetuar operaçao neg
								  SelRegWr <= 1'b0; // multiplexador libera o canal para o endereço de escrita								  
								  selDtWr <= 2'b00;  // multiplexador libera o canal para o dado do resultado ula para o banco
								  Wr <= 1'b1;       // envia sinal ativo para escrever no banco registrador
					        end
					  opNOT:begin
					           CmdULA <= cmdNOT; // envia comando para ula efetuar operaçao not
								  SelRegWr <= 1'b0; // multiplexador libera o canal para o endereço de escrita								  
								  selDtWr <= 2'b00;  // multiplexador libera o canal para o dado do resultado ula para o banco
								  Wr <= 1'b1;       // envia sinal ativo para escrever no banco registrador
							  end					  
					  opCPY:begin
								  CmdULA <= cmdTSTR1; // envia comando para ula que retorna o registrador r1
								  selDtWr <= 2'b00;   // multiplexador libera o resultado da ula para dadoWR
					           SelRegWr <= 1'b0;   // multiplexador libera o canal para o endereço de escrita
								  selDtWr <= 2'b00;  // multiplexador libera o canal para o dado do resultado ula para o banco
								  Wr <= 1'b1;         // envia sinal ativo para escrever no banco registrador
					        end
					  opLRG: begin
					            SelRegWr <= 1'b1;  // multiplexador libera o canal para o endereço do registrador R1
					            selDtWr <= 2'b01;  // multiplexador libera o canal para o dado imediato
									Wr <= 1'b1;			 // envia sinal ativo para escrever no banco registrador
								end
					  opBLT:begin
									CmdULA <= cmdTSTR1;     // envia comando para ula que retorna o registrador r1
									if(ResultULA[7] == 1) 	// verifica o bit na posição 7 do resultULA e executa
										begin											
											SelDesv <= 1'b1;	// multiplexador libera o canal para o resultado do somador de PC + 1, com o campo imediato
											SelJMP = 1'b0;		// multiplexador libera o canal para PC com o resultado do desvio
										end
									else
										begin											
											SelDesv <= 1'b0;	// multiplexador libera o canal para o resultado do somador de PC + 1
											SelJMP <= 1'b0;	// multiplexador libera o canal para PC com o resultado do desvio
										end
							  end
					  opBGT:begin
									CmdULA <= cmdTSTR1;     // envia comando para ula que retorna o registrador r1
									if(ResultULA[7] == 0) 	// verifica o bit na posição 7 do resultULA e executa
										begin											
											SelDesv <= 1'b1;	// multiplexador libera o canal para o resultado do somador de PC + 1, com o campo imediato
											SelJMP = 1'b0;		// multiplexador libera o canal para PC com o resultado do desvio
										end
									else
										begin											
											SelDesv <= 1'b0;	// multiplexador libera o canal para o resultado do somador de PC + 1
											SelJMP <= 1'b0;	// multiplexador libera o canal para PC com o resultado do desvio
										end
							  end
					  opBEQ:begin
									CmdULA <= cmdTSTR1;     // envia comando para ula que retorna o registrador r1
									if(ResultULA == 0) 		// verifica o resultULA e executa
										begin											
											SelDesv <= 1'b1;	// multiplexador libera o canal para o resultado do somador de PC + 1, com o campo imediato
											SelJMP = 1'b0;		// multiplexador libera o canal para PC com o resultado do desvio
										end
									else
										begin											
											SelDesv <= 1'b0;	// multiplexador libera o canal para o resultado do somador de PC + 1
											SelJMP <= 1'b0;	// multiplexador libera o canal para PC com o resultado do desvio
										end
							  end
					  opBNE:begin
									CmdULA <= cmdTSTR1;     // envia comando para ula que retorna o registrador r1
									if(ResultULA != 0) 		// verifica o resultULA e executa
										begin											
											SelDesv <= 1'b1;	// multiplexador libera o canal para o resultado do somador de PC + 1, com o campo imediato
											SelJMP = 1'b0;		// multiplexador libera o canal para PC com o resultado do desvio
										end
									else
										begin											
											SelDesv <= 1'b0;	// multiplexador libera o canal para o resultado do somador de PC + 1
											SelJMP <= 1'b0;	// multiplexador libera o canal para PC com o resultado do desvio
										end
							  end
					  opJMP:begin
							      SelDesv <= 1'b1;   // multiplexador libera o canal para o resultado do somador de PC + 1, com o campo imediato
									SelJMP <= 1'b0;    // multiplexador libera o canal para PC com o resultado do desvio
							  end
					  opINPUT:begin
					            SelRegWr <= 1'b0;  // multiplexador libera o canal para o endereço de escrita
					            selDtWr <= 2'b10;  // multiplexador libera o canal para o dado da placa
									Wr <= 1'b1;			 // envia sinal ativo para escrever no banco registrador
								 end
					  opOUTPUT:begin
										CmdULA <= cmdTSTR1; //manda a ula retornar como resultado o valor do registrador 1
										
										SelRegWr <= 1'b0;	  //como a instuçao output foi setada, seu endereço de destino está
																  //numa das entradas do multiplexador, chaveando para 0 o endereço
																  //de destino sérá passado ao resultado do multiplexador, esse resultado
																  //está ligado ao modulo exit, que usa este endereço para dizer a qual saida
																  //o resultULA será destinado 
										
								  end 		
					endcase  
				   estado <= 3'd3; //
				 end
			 3: begin  // prepara a carga da próxima instrução
					LdPC <= 1'b1;
					estado <= 3'd0; //
//			      Wr <= 1'b0;
//					estado <= 3'd4; 
					case (OP)
			        opJMP: SelJMP <= 1'b1;
					  opBEQ: SelDesv <= (ResultULA == 8'd0 ? 1'b1 : 1'b0);
					  opOUTPUT:  LdOUTPUT <= 1'b1; 
					  default: begin
									 SelJMP = 0;
									 SelDesv = 0;
								  end
			      endcase
				 end
//			 4: begin
//			      estado <= 3'd0; 
//					LdPC <= 1'b1;
//				 end
			 default:; 	 
		  endcase  
		end
  end
  
  
endmodule 