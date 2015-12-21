/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
//package producerconsumer;

import java.lang.InterruptedException;

public class BoundedBuffer {
    public static int pThreadCount = 1;
    public static int cThreadCount = 1;
    public static int itemsInBuffer = 0;
    public static int itemCount = 1;
    private static int in = 0; // slot for next insertion
    private static int out = 0; // slot for next removal 
    public  static Item buffer[];
    private static Object lock = new Object();
//    private Object pLock = new Object();
//    private Object cLock = new Object();
    public static int bufferSize = 0;
    public static int quota;
    
    public BoundedBuffer(int size, int q) {
        quota = q;
        bufferSize = size;
        buffer = new Item[size];
    }
    public BoundedBuffer(int size, int q, Item[] b) {
        quota = q;
        bufferSize = size;
        buffer = b;
    }
    //this is the producer
    public static void insert(Item item, Producer p) throws InterruptedException{
            //begin by checking to see if you hold the lock
            synchronized(lock) {
    //        when there is no space available (before the producer blocks) print
                while(itemsInBuffer == bufferSize) {
                    //Let the user know you are waiting to obtain the lock
                    System.out.println(p.toString() + " waiting to insert " + item.toString());
                    try {
                        lock.wait();
                    }
                    catch (InterruptedException e) {
                        System.out.println(p.toString() + " is terminating gracefully.");
                        throw new InterruptedException();
                    }
                }
//                while(itemsInBuffer < bufferSize) {
        //          add the item to the buffer 
                    buffer[in] = item;
                    itemsInBuffer++;
                    itemCount++;
                    //increment the in variable and release the lock
                    in = (in +1) % bufferSize;
                    System.out.println(p.toString() + " inserted " + item.toString() + "\t(" + itemsInBuffer + " of " + bufferSize + " slots full)");                
//                }
                //release the lock
                lock.notifyAll();
            }
    }
    
    	//this is the consumer
    public static Item remove(Consumer c) throws InterruptedException {
        //initialize the item to null because you may return a null item
        Item item = null;
            //check to see if you hold the lock
            synchronized(lock) {
                //while the buffer is empty there is nothing to consume so just wait
                while(itemsInBuffer == 0) {
                    System.out.println(c.toString() + " waiting to remove an item");
                    try {
                        lock.wait();
                    }
                    catch (InterruptedException e) {
                        System.out.println(c.toString() + " is terminating gracefully.");
                        throw new InterruptedException();
                    }
                }
//                while(itemsInBuffer > 0) {
                    //once the buffer is not empty we will reach this step so remove the item from the buffer
                    item = buffer[out];
                    buffer[out] = null;
                    itemsInBuffer--;
                    out = (out+1) % bufferSize;
                    System.out.println(c.toString()  + " removed " + item.toString() + "\t(" + itemsInBuffer + " of " + bufferSize + " slots full)");
//                }
                //release the lock
                lock.notifyAll();
            }
        return item;
    }      
	public String toString() {
		String output = "[";
		for(int i = 0; i < bufferSize; i++) {
			if ( i == bufferSize - 1) {
				output += buffer[i].toString() + "]";
			}
			else {
				output += buffer[i].toString() + ", ";
			}
		}
		return output;
	}
}

