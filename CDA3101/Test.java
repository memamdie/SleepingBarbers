import java.util.*;
import java.io.*;
public class Test {
	static int[] registers = new int[32];
	static int[] memRegisters = new int[16];
	static int cycleNumber = 1;
	public static void main(String[] args) {
		String input = "";
		int z = 0;
		int y = 0;
		try {
			Scanner sc = new Scanner(new FileReader("givenDis.txt"));
			ArrayList<Integer> address = new ArrayList<Integer>();
			ArrayList<String> instruction = new ArrayList<String>();
			while(true) {
				input = sc.nextLine();
				instruction.add(input.substring(37));
				address.add(Integer.parseInt(input.substring(33,36)));
				if(input.contains("BREAK")) {
					break;
				}
				z++;
			}
			ArrayList<Integer> memValue = new ArrayList<Integer>();
			ArrayList<Integer> memLocation = new ArrayList<Integer>();
			int q = 0;
			while(true) {
				input = sc.nextLine();
				memLocation.add(Integer.parseInt(input.substring(33,36)));
				memValue.add(Integer.parseInt(input.substring(37)));
				registers[q] = Integer.parseInt(input.substring(37));
				if(!sc.hasNextLine()) {
					break;
				}
				
				y++;
			}
			printout(instruction.get(0), address.get(0), registers);
			operate(instruction, memLocation, memValue, registers);
		}
		
		catch (FileNotFoundException fnfe) {
			// Do something useful with that error
			// For example:
			System.out.println(fnfe);
		}
	}
	static void operate(ArrayList<String> s, ArrayList<Integer> memLoc, ArrayList<Integer> memVal, int[] r) {
		int i = 0;
		while(true) {
			String instr = s.get(i);
			if(instr.contains("BREAK")) {
				break;
			}
			else if(instr.contains("J")) {
				String addr = instr.substring(3);

			}
			else if(instr.contains("BEQ")) {
				int locDest = instr.indexOf("#");				
				String dest = instr.substring(locDest + 1);		
				int locS1= instr.indexOf("R");
				String source1 = instr.substring((locS1+1), (locS1 + 2));
				if(Character.isDigit(instr.charAt(locS1+2))) {
					source1 += instr.charAt(locS1+2);
				}
				int locS2= instr.indexOf(",");
				String source2 = instr.substring((locS2+3), locS2+4);
				if(Character.isDigit(instr.charAt(locS2+4))) {
					source2 += instr.charAt(locS2+4);
				}

			}
			else if(instr.contains("BGTZ")) {
				int locDest = instr.indexOf("#");				
				String dest = instr.substring(locDest + 1);		
				int locS1= instr.indexOf("R");
				String source1 = instr.substring((locS1+1), (locS1 + 2));
				if(Character.isDigit(instr.charAt(locS1+2))) {
					source1 += instr.charAt(locS1+2);
				}
			}
			else if(instr.contains("SW")) {
				int locDest = instr.lastIndexOf("R");
				String dest = instr.substring(locDest+1, locDest+2);
				if(Character.isDigit(instr.charAt(locDest + 2))) {
					dest += instr.charAt(locDest + 2);
				}
				int locSource = instr.indexOf("R");
				String source = instr.substring(locSource+1, locSource+2);
				if(Character.isDigit(instr.charAt(locSource + 2))) {
					source += instr.charAt(locSource + 2);
				}
				int locOffset = instr.indexOf(",");
				String offset = instr.substring(locOffset + 2, locOffset+3);
				if(Character.isDigit(instr.charAt(locOffset + 3))) {
					offset += instr.charAt(locOffset + 3);
				}
				if(Character.isDigit(instr.charAt(locOffset + 4))) {
					offset += instr.charAt(locOffset + 4);
				}
			}
			else if(instr.contains("LW")) {
				int locDest = instr.indexOf("R");
				String dest = instr.substring(locDest+1, locDest+2);
				if(Character.isDigit(instr.charAt(locDest + 2))) {
					dest += instr.charAt(locDest + 2);
				}
				int locSource = instr.lastIndexOf("R");
				String source = instr.substring(locSource+1, locSource+2);
				if(Character.isDigit(instr.charAt(locSource + 2))) {
					source += instr.charAt(locSource + 2);
				}
				int locOffset = instr.indexOf(",");
				String offset = instr.substring(locOffset + 2, locOffset+3);
				if(Character.isDigit(instr.charAt(locOffset + 3))) {
					offset += instr.charAt(locOffset + 3);
				}
				if(Character.isDigit(instr.charAt(locOffset + 4))) {
					offset += instr.charAt(locOffset + 4);
				}
			}			
			else if(instr.contains("ADDI") || instr.contains("ANDI") || instr.contains("ORI") || instr.contains("XORI")) {
				int locDest = instr.indexOf(" ");				
				String dest = instr.substring(locDest + 2, locDest + 3);
				if(Character.isDigit(instr.charAt(locDest + 3))) {
					dest += instr.charAt(locDest + 3);
				}
				
				int locS1= instr.indexOf(",");
				String source1 = instr.substring((locS1+3), (locS1 + 4));
				if(Character.isDigit(instr.charAt(locS1+4))) {
					source1 += instr.charAt(locS1+4);
				}
				int locS2= instr.indexOf("#");
				String source2 = instr.substring((locS2+1));
			}
			else if(instr.contains("ADD") || instr.contains("SUB") || instr.contains("MUL") || instr.contains("AND") || instr.contains("OR") || instr.contains("XOR") || instr.contains("NOR")) {
				String dest = instr.substring(5,6);
				if(Character.isDigit(instr.charAt(6))) {
					dest += instr.charAt(6);
				}
				
				int locS1= instr.indexOf(",");
				String source1 = instr.substring((locS1+3), (locS1 + 4));
				if(Character.isDigit(instr.charAt(locS1+4))) {
					source1 += instr.charAt(locS1+4);
				}
				int locS2 = instr.lastIndexOf("R");
				String source2 = instr.substring((locS2+1));
			}
			else {
				//throw new Exception("You have managed to enter an instruction that is not recognized in this program.");
			}
			i++;
		}
	}
	static void printout(String operation, int address, int[] r) {
		try {
			FileWriter outFile = new FileWriter("sim.txt");
		 	PrintWriter out = new PrintWriter(outFile);
			int index = 0;
			//while(true) {
				out.println("--------------------");
				out.print("Cycle:" + cycleNumber + " " + address + " " + operation + "\n\nRegisters\nR00:");
				for(int i = 0; i < 32; i++) {
					if(i == 8) {
						out.print("\nR08:");
					}
					if(i == 16) {
						out.print("\nR16:");
					}
					if(i == 24) {
						out.print("\nR24:");
					}
					out.print("\t" + r[i]);
				}
				out.print("\n\nData\n184:");
				for(int i = 0; i < 16; i++) {
					if(i == 8) {
						out.print("\n216:");
					}
					out.print("\t" + memRegisters[i]);
				}
				out.println();
				cycleNumber++;
			//}
		}
		catch (IOException e) {
			System.out.println(e);
		}
	}
}
