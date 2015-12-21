import java.util.*;

public class Bathroom {

	private final Queue<Person> queue;
	private final ArrayList<Person> occ;
	public final int numOfToilets;
	private String occGender="";
	public Bathroom(int numOfToilets) {
		this.numOfToilets = numOfToilets;
		queue = new LinkedList<Person>();
		occ = new ArrayList<Person>();
	}

	public void enter(Person attempting) {
		Person eligiblePerson;
		synchronized (this) {
			queue.add(attempting);
			eligiblePerson = eligiblePerson();
		}
                if(attempting.gender == "female" && occGender == "false") {
                    while(occ.size() > 0 && occGender == "male") {
                        System.out.println("Kicking out " + occ.get(0).name + " so ladies dont have to wait");
                        leave(occ.get(0));
                    }
                    synchronized (this) {
				queue.remove(attempting);
				occ.add(attempting);
                                occGender = attempting.gender;
			}
                }
                else if (attempting != eligiblePerson) {
			synchronized (attempting) {
				try {
                                    System.out.println(attempting.name + "is waiting to enter");
                                    attempting.wait();
				} catch (InterruptedException interruptedException) {
					interruptedException.printStackTrace();
				}
			}
		} else {
			synchronized (this) {
				queue.remove(attempting);
				occ.add(attempting);
                                occGender = attempting.gender;
			}
		}
	}
	public synchronized void leave(Person leavingPerson) {
		occ.remove(leavingPerson);
                System.out.println(leavingPerson.name + " left the toilet.");
                leavingPerson.leftBathroom = true;
                leavingPerson.interrupt();
		Person eligiblePerson = eligiblePerson();
		while (eligiblePerson != null) {
			eligiblePerson = eligiblePerson();
			if (eligiblePerson != null) {
				queue.remove(eligiblePerson);
				occ.add(eligiblePerson);
                                occGender = eligiblePerson.gender;
				synchronized (eligiblePerson) {
					eligiblePerson.notify();
				}
			}
		}
	}
	private Person eligiblePerson() {
		Person eligiblePerson;
//                if(queue.size() > 0 && occ.size() > 0 && occGender == "male" && queue.element().gender == "female") {
//                    while(occ.size() > 0 && occGender == "male") {
//                        System.out.println("Kicking out " + occ.get(0).name);
//                        leave(occ.get(0));
//                    }
//                }
//                if(occGender == "male"&& queue.size() > 0 && queue.element().gender == "female" && occ.size() > 0) {                
//                        while(occ.size() > 0 && occGender == "male"&& queue.element().gender == "female") {
//                            String tempName = queue.element().name;
//                            System.out.println(occ.get(0).name + "evacuating the bathroom for " + tempName);
//                            leave(occ.get(0));
//                        }
//                        while(!queue.isEmpty()) {
//                            queue.remove();
//                        }
//                }
		if (queue.size() > 0 && occ.size() < numOfToilets) {
			if (occ.iterator().hasNext()) {
				if (occ.iterator().next().gender == "male") {
					if (queue.peek().gender == "male") {
						eligiblePerson = queue.peek();
					} 
					else {
						eligiblePerson = null;
					}
				} 
				else {
                                    if (queue.peek().gender == "female") {
                                            eligiblePerson = queue.peek();
                                    } 
                                    else {
                                            eligiblePerson = null;
                                    }
				}
			} 
			else {
				eligiblePerson = queue.peek();
			}
		} 
		else {
			eligiblePerson = null;
		}
		
		return eligiblePerson;
	}
}
