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
#include <sys/types.h>
#include <sys/queue.h>
#include <pthread.h>

typedef struct {
    int value, initialCount, currentSleepCount;	 //The value will be incremented and decremented as it is flagged up and down
	pthread_mutex_t mutex;		 // The lock that will be used to add and remove elements from the singular queue 
	pthread_cond_t cond;	
//	SIMPLEQ_HEAD(queue, simpleq);
} semaphore_t;

typedef struct {
	pthread_cond_t i;            // data
//	SIMPLEQ_ENTRY(entry) next;   // link to next entry
} simpleq;
semaphore_t* createSemaphore(int initialCount);

void destroySemaphore( semaphore_t* sem);

void down(semaphore_t* sem);

void up(semaphore_t* sem);

#endif /* semaphore_h */
