/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
//package producerconsumer;


public class Item {
    int id;
    Item() {
        id = BoundedBuffer.itemCount;
    }
    public String toString() {
        return "Item #" + id;
    }  
}

