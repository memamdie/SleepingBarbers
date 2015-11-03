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
	semaphore_t* semaphore;
//	SIMPLEQ_INIT(&queue);
	//Allocate space for a semaphore
    semaphore = (semaphore_t *) malloc(sizeof(semaphore_t));
	//Store the initialCount for future reference
	semaphore-> initialCount = initialCount;
	//Set the initial value for the semaphore
    semaphore->value = initialCount;
	//Initialize the mutex
	semaphore -> mutex = malloc(sizeof(pthread_mutex_t));
	pthread_mutex_init(&semaphore->mutex, NULL);
	//Initialize the condition
	semaphore -> cond = malloc(sizeof(pthread_cond_t));
	pthread_cond_init(&semaphore->cond, NULL);

	//semaphore -> head = SIMPLEQ_HEAD_INITIALIZER(head);
	//printf("\nHey look a semaphore was created with a value of %d\n", semaphore->value);
	//fflush(stdout);
//	Return the newly created semaphore
    return semaphore;
}

void cleanUp(void* sem) {
	semaphore_t* semaphore = (semaphore_t*) sem;
	pthread_mutex_unlock(&semaphore -> mutex);
	//printf("Cleaned that shit up and unlocked the mutex on %d", semaphore->value);
	//fflush(stdout);
}

void down(semaphore_t* sem) {
//	pthread_cond_t* newCondition;
//	pthread_cond_init(newCondition, NULL);
	pthread_mutex_lock(&sem->mutex);
		if(sem->value <= 0) {
			//SIMPLEQ_INSERT_TAIL( &head, newCondition, next );
			sem->currentSleepCount +=1;
			pthread_cleanup_push(cleanUp, sem);
			pthread_cond_wait(&sem->cond,&sem->mutex);
			pthread_cleanup_pop(0);
			
			pthread_mutex_unlock(&sem->mutex);
		}
		
		sem -> value -= 1;
	pthread_mutex_unlock(&sem->mutex);
}

void up(semaphore_t* sem) {
	pthread_mutex_lock(&sem->mutex);
		
		if(sem -> currentSleepCount > 0) {
			pthread_cond_signal(&sem->cond);
			sem -> currentSleepCount -= 1;
			
			pthread_mutex_unlock(&sem->mutex);
		}
		sem -> value += 1;
	pthread_mutex_unlock(&sem->mutex);
}

void destroySemaphore(semaphore_t* sem) {
	//Free the memory that was allocated for this semaphore	
	pthread_mutex_destroy(&sem->mutex);
	pthread_cond_destroy(&sem->cond);
	free(sem);
	//printf("\nHey look a semaphore was deleted with a value of %d\n", semaphore->value);
	//fflush(stdout);

}