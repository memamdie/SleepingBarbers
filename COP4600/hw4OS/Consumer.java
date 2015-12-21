/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

//package producerconsumer;

import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;


public class Consumer extends Thread {
    int unique_id = 0;
    int quotaGiven;
    int Low = 10;
    int High = 100;
    int time, temp, totalTime;
    int itemsConsumed = 0;
    Random r = new Random();
    BoundedBuffer buffer;
    //default constructor takes in the quota size
    Consumer(int quota) {
        quotaGiven = quota;
        unique_id = BoundedBuffer.cThreadCount++;
    }
    //called from the main when the main calls .start()
    public void run() {
        quotaGiven = r.nextInt(91)+10;
        temp = r.nextInt(5) + 1;
        //iterate until you have consumed the number of items to meet the quota
        outerloop: for(int i = 0; i < quotaGiven; i++) {
            System.out.println(this.toString() + " is ready to consume " + quotaGiven + " items." );
            time = r.nextInt(High-Low + 1) + Low;
            totalTime += time;
            try {            
                for(int f = 0; f < temp; f++) {
                    Item item = BoundedBuffer.remove(this);
                    itemsConsumed++;
                    temp = r.nextInt(5) + 1;
                }
                System.out.println(this.toString() + " is napping for " + time + " ms.");
                try {
                    Thread.sleep(time);
                }
                catch(InterruptedException e) {
                    System.out.println(this.toString() + " terminated GRACEFULLY");
                    System.out.println(getStatus());
                    break outerloop;
                }
            } 
            catch (InterruptedException ex) {
                System.out.println(this.toString() + " terminated GRACEFULLY");
                System.out.println(getStatus());
                break outerloop;
            }
        }
        System.out.println(this.toString() + " TERMINATED.");
    }
    public String getStatus() {
        return "Consumer " +  unique_id  + " consumed " + itemsConsumed + " items and slept " + totalTime + " ms";
    }
    public String toString() {
        return "Consumer" + unique_id;
    }
}

