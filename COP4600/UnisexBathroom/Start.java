
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Start {
	public static void main(String args[]) {
            Bathroom bathroom = new Bathroom(10);
            for(int i = 0; i < 10; i++) {
                    new Person(i, bathroom, "female").start();
            }
            for(int i = 0; i < 10; i++) {
                    new Person(i, bathroom, "male").start();
            }
            ExecutorService exec = Executors.newFixedThreadPool(bathroom.numOfToilets);

	}
}