import java.util.*;
import java.io.*;
//public class MyException extends Exception {}
public class CDAProject2 {
	public static void main(String[] args) {
   		try {
			File inputFile = new File( args[0]);
			String input = "";
			Scanner s = new Scanner(new FileReader(inputFile));
			int address = 128;
			FileWriter outFile = new FileWriter("disassembly.txt");
         		PrintWriter out = new PrintWriter(outFile);
			while(true) {
				input = s.nextLine();
				//System.out.println(input);
				//System.out.println(input + " " + address + " "+ classify(input));
				String output = classify(input, address);
				out.println(input + "\t" + address + "\t" + output);
				address += 4;
				if(output.contains("BREAK")) {
					break;
				}
			}
			String value = "";
			while(true) {
				input = s.nextLine();
				if(input.charAt(0) == '0') {
					value = String.valueOf(Long.parseLong(input, 2));
					out.println(input + "\t" + address + "\t" + value);
					address += 4;
				}
				else if (input.charAt(0) == '1') {
					int index = input.lastIndexOf('1');	
					String str = "";
					for(int g = 0; g < index; g++) {
						if(input.charAt(g)== '0') {
							str += "1";
						}
						else if(input.charAt(g) == '1') {
							str += "0";
						}
					}
					for(int j = index; j < input.length(); j++) {
						str += input.charAt(j);
					}
					str = String.valueOf(Long.parseLong(str, 2));
					out.println(input + "\t" + address +  "\t-" + str);
					address += 4;
				}
				else {
					//throw not binary exception
				}
				if(s.hasNextLine() == false) {
					break;
				}
			}
			out.close();
    		} 
		catch (FileNotFoundException fnfe) {
			// Do something useful with that error
			// For example:
			System.out.println(fnfe);
		}
		catch (IOException e) {
			System.out.println(e);
		}
	}
	static String classify(String a, int address) {
		String start = a.substring(0,2);
		String operation = "";
		String instruction = "";
		String registers = "";
		String opcode, offset, source, temp;
		//try {
			if(start.equals("00")) {
				opcode= a.substring(2,6);
				//J instruction
				if(opcode.equals("0000")) {
					operation = "J";	
					offset = a.substring(6);
					offset = String.valueOf((short)Integer.parseInt(offset, 2) * 4);
					registers = "#" + offset;
				}
				//BEQ instruction
				else if(opcode.equals("0010")) {
					operation = "BEQ";
					source = a.substring(6,11);
					source = String.valueOf((short)Integer.parseInt(source, 2));
					temp = a.substring(11,16);
					temp = String.valueOf((short)Integer.parseInt(temp, 2));
					offset = a.substring(16);
					offset = String.valueOf((short)Integer.parseInt(offset, 2) * 4);
					registers = "R" + source + ", R" + temp + ", #" + offset;
				}
				//BGTZ instruction
				else if(opcode.equals("0100")) {
					operation = "BGTZ";
					source = a.substring(6,11);
					source = String.valueOf((short)Integer.parseInt(source, 2));
					offset = a.substring(16);
					offset = String.valueOf((short)Integer.parseInt(offset, 2) * 4);
					registers = "R" + source + ", #" + offset;
				}				
				//BREAK instruction
				else if(opcode.equals("0101")) {
					operation = "BREAK";
					source = a.substring(6,26);
					offset = "001101";
				}
				//SW instruction
				else if(opcode.equals("0110")) {
					operation = "SW";
					source = a.substring(6,11);
					source = String.valueOf((short)Integer.parseInt(source, 2));
					temp = a.substring(11,16);
					temp = String.valueOf((short)Integer.parseInt(temp, 2));
					offset = a.substring(16);
					offset = String.valueOf((short)Integer.parseInt(offset, 2));
					registers = "R" + temp + ", " + offset + "(R" + source + ")";
				}
				//LW instruction
				else if(opcode.equals("0111")) {
					operation = "LW";
					source = a.substring(6,11);
					source = String.valueOf((short)Integer.parseInt(source, 2));
					temp = a.substring(11,16);
					temp = String.valueOf((short)Integer.parseInt(temp, 2));
					offset = a.substring(16);
					offset = String.valueOf((short)Integer.parseInt(offset, 2));
					registers = "R" + temp + ", " + offset + "(R" + source + ")";
				}
				//throw invalid rest of string
				else {

				}
			}
			else if(start.equals("01")) {
				opcode = a.substring(12,16);
				source = a.substring(2,7);
				source = String.valueOf((short)Integer.parseInt(source, 2));
				temp = a.substring(7,12);
				temp = String.valueOf((short)Integer.parseInt(temp, 2));
				offset = a.substring(16,21);
				offset = String.valueOf((short)Integer.parseInt(offset, 2));
				registers = "R" + offset + ", R" + source + ", R" + temp;
				//ADD instruction
				if(opcode.equals("0000")) {
					operation = "ADD";
				}
				//SUB instruction
				else if(opcode.equals("0001")) {
					operation = "SUB";
				}
				//MUL instruction
				else if(opcode.equals("0010")) {
					operation = "MUL";
				}
				//AND instruction
				else if(opcode.equals("0011")) {
					operation = "AND";
				}
				//OR instruction
				else if(opcode.equals("0100")) {
					operation = "OR";
				}
				//XOR instruction
				else if(opcode.equals("0101")) {
					operation = "XOR";
				}
				//NOR instruction				
				else if(opcode.equals("0110")) {
					operation = "NOR";
				}			
				else {
					//throw exception
				}
			}
			else if(start.equals("10")) {
				source = a.substring(2,7);
				source = String.valueOf((short)Integer.parseInt(source, 2));
				temp = a.substring(7,12);
				temp = String.valueOf((short)Integer.parseInt(temp, 2));
				opcode = a.substring(12,16);
				offset = a.substring(16);
				offset = String.valueOf((short)Integer.parseInt(offset, 2));
				registers = "R" + temp + ", R" + source + ", #" + offset;
				//ADDI instruction
				if(opcode.equals("0000")) {
					operation = "ADDI";
				}
				//ANDI instruction
				else if(opcode.equals("0001")) {
					operation = "ANDI";
				}
				//ORI instruction
				else if(opcode.equals("0010")) {
					operation = "ORI";
				}
				//XORI instruction
				else if(opcode.equals("0011")) {
					operation = "XORI";
				}
				else {
					//throw exception
				}
			}
			/*else {
				throw new MyException("The first two bits are not classified as one of the available MIPS instructions");
			}
		}
		catch(MyException e) {
			System.out.println(e);
		}*/
		
		return operation + " " + registers;
	}
	/*static String toDecimal(String b) {
		int decimal = 0;
		int power = 0;
		int binary = Integer.parseInt(b);
		while(true){
			if(binary == 0){
				break;
			} 
			else {
				int temp = binary % 10;
				decimal += temp * Math.pow(2, power);
				binary /= 10;
				power++;
			}
		}
		String stringDecimal = Integer.toString(decimal);
		return stringDecimal;     
	}*/
	static void simulation() {
		
	}
}
