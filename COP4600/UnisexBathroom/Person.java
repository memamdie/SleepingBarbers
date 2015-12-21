import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Person extends Thread {

	protected Bathroom bathroom;
	protected int id;
        final int IDLE_TIME = 1;
        final int BATHROOM_TIME = 2;
        
        protected String gender, name; 
        
        protected boolean leftBathroom = false;
        
	public Person(int id, Bathroom bathroom, String gender) {
		this.id = id;
		this.bathroom = bathroom;
                this.gender = gender;
                if(gender == "female") {
                    name = "Woman " + id + " "; 
                }
                else {
                    name = "Man " + id + " ";
                }
	}
        @Override
        public void run() {
            try {   
                int time = new Random().nextInt(IDLE_TIME * 1000);
                    System.out.println("Upon starting, " + name + "is attempting to sleep for " + time + " ns.");
                    Thread.sleep(time);
            } catch (InterruptedException interruptedException) {
                    interruptedException.printStackTrace();
            }

            bathroom.enter(this);
            System.out.print(name + " entered the toilet.\n");
            if(!leftBathroom) {
                int time = new Random().nextInt(BATHROOM_TIME * 1000);
                System.out.println(name + "is using the bathroom for " + time + " ns.");
                try {
                    Thread.sleep(time);
                    bathroom.leave(this);
                }catch (InterruptedException interruptedException) {
                }
            
//                System.out.print(name + " left the toilet.\n");
//                
//		leftBathroom = true;
//                Thread.currentThread().interrupt();
            }
            else {
                Thread.currentThread().interrupt();
            }

	}
}
