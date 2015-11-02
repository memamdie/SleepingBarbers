//
//  semaphore.h
//  SleepingBarbers
//
//  Created by Michelle Emamdie on 10/29/15.
//  Copyright © 2015 Michelle Emamdie. All rights reserved.
//

#ifndef semaphore_h
#define semaphore_h

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/queue.h>
#include <pthread.h>
//#include <semaphore.h>

typedef struct {
    int value;	 //The value will be incremented and decremented as it is flagged up and down
	pthread_mutex_t* mutex;		 // The lock that will be used to add and remove elements from the singular queue 
	pthread_cond_t* cond;
//	SIMPLEQ_ENTRY(entry) next;   // link to next entry
//	SIMPLEQ_HEAD(queuehead, entry) head;
} semaphore_t;

semaphore_t* semaphore;

semaphore_t* createSemaphore(int initialCount);

void destroySemaphore( semaphore_t* sem);

void down(semaphore_t* sem);

void up(semaphore_t* sem);

#endif /* semaphore_h */
