/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
//package producerconsumer;

import java.util.logging.Level;
import java.util.logging.Logger;

public class ProducerConsumerDemo{
    static final int quota = 20;
    static final int bufferSize = 3;
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        BoundedBuffer buff= new BoundedBuffer(bufferSize, quota);
        Consumer c1 = new Consumer(quota);
        Consumer c2 = new Consumer(quota);
        Producer p1 = new Producer(quota);
        Producer p2 = new Producer(quota);
        c1.start();
        c2.start();
        p1.start();
        p2.start();
        try {
            Thread.sleep(1000);
            c1.interrupt();
            c2.interrupt();
            p1.interrupt();
            p2.interrupt();
//            c1.setStop(true);
//            c2.setStop(true);
//            p1.setStop(true);
//            p2.setStop(true);
        } catch (InterruptedException ex) {
            Logger.getLogger(ProducerConsumerDemo.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        System.out.println("Process ProducerConsumerDemo finished");
    }
    
}

