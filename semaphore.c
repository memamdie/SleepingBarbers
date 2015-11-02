//
//  semaphore.c
//  SleepingBarbers
//
//  Created by Michelle Emamdie on 10/29/15.
//  Copyright © 2015 Michelle Emamdie. All rights reserved.
//

#include "semaphore.h"

// SEMAPHORE

semaphore_t* createSemaphore(int initialCount) {
	//Allocate space for a semaphore
    semaphore = (semaphore_t *) malloc(sizeof(semaphore_t));
	//Set the initial value for the semaphore
    semaphore->value = initialCount;
	//Initialize the mutex
	semaphore->mutex = PTHREAD_MUTEX_INITIALIZER;
	//Initialize the condition
	semaphore->cond = PTHREAD_COND_INITIALIZER;
	printf("\nHey look a semaphore was created with a value of %d\n", semaphore->value);
//	Return the newly created semaphore
    return semaphore;
}

void down(semaphore_t* sem) {
	printf("Locking the mutex on down\n");
	if (pthread_mutex_lock(sem -> mutex)) {
		printf("Mutex has been locked on down\n");
	}
	if(sem->value == 0) {
		printf("Thread is going to start waiting\n");
		pthread_cond_wait(sem->cond,sem->mutex);
	}
	if(pthread_mutex_unlock(sem -> mutex)) {
		printf("Thread %d has been unlocked\n", sem -> value);
	}
}

void up(semaphore_t* sem) {
	printf("Locking the mutex\n");
	if (pthread_mutex_lock(sem -> mutex)) {
		printf("Mutex has been locked on up\n");
	}
	//wake it up
	if(sem -> value != 0) {
		pthread_cond_signal(sem->cond);
		printf("Wake up damn thread %d!\n", sem -> value);
	}
	if(pthread_mutex_unlock(sem -> mutex)) {
		printf("Thread %d has been unlocked\n", sem -> value);
	}
	//release the lock on the semaphore

}
void destroySemaphore(semaphore_t* sem) {
	//Free the memory that was allocated for this semaphore	
	pthread_mutex_destroy(sem->mutex);
	pthread_cond_destroy(sem->cond);
	free(sem);
	printf("\nHey look a semaphore was deleted with a value of %d\n", semaphore->value);

}