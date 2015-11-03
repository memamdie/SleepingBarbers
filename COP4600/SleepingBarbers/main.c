
#include "semaphore.h"


#define NUM_BARBERS 2
#define NUM_CHAIRS 5
#define NUM_CUSTOMERS 10

semaphore_t* customerSem; /* # waiting customers */
semaphore_t* barberSem; /* # active barb */
semaphore_t* mutex;
int waiting;
int i;
int Number[NUM_CUSTOMERS];
pthread_t barb[NUM_BARBERS];
pthread_t customers[NUM_CUSTOMERS];

void cut_hair(void* id) {
	usleep(10000);
	printf("Barber %d is cutting a customer's hair\n",(int) id);
	fflush(stdout);

}
void receive_haircut(void* id) {
	usleep(10000);
	printf("Customer %d is receiving a haircut\n", (int)id);
	fflush(stdout);
}
void* barber(void* i) {
	 while (1) {
		 printf("Barber %d goes to sleep\n", (int) i);
		 fflush(stdout);
		 down( customerSem );
		 printf("Barber %d wakes up\n",(int) i);
		 fflush(stdout);
		 down( mutex );
		 usleep(100);
		 --waiting;
		 printf("Barber %d beckons a customer to the chair  [%d customer(s) waiting]\n", (int) i, barberSem->currentSleepCount);
		 fflush(stdout);
		 up( barberSem );
		 up( mutex );
		 cut_hair(i);
	 } 
	return NULL;
}
void* customer(void* i) {
	down( mutex );
	 if ( waiting < NUM_CHAIRS ) {
		 ++waiting;
		 printf("Customer %d wakes barber\n", (int)i);
		 fflush(stdout);
		 up( customerSem ); /* wake a sleeping barber, if any */
		 up( mutex );
		 printf("Customer %d waits in the chair [%d customer(s) waiting]\n", (int)i, barberSem->currentSleepCount);
		 fflush(stdout);
		 down( barberSem ); /* wait for barber to wave over */
		 printf("Customer %d sits in barbers chair\n", (int) i);
		 fflush(stdout);
		 receive_haircut(i);
		printf("Customer %d leaves with a stylish haircut\n",(int) i);
		fflush(stdout);
	 }
	 else {
		up( mutex ); 
		usleep(100);
		printf("There were no empty chairs so customer %d left without getting a haircut\n", (int) i);
	 }
	return NULL;
}

int main() {
	customerSem = createSemaphore(0);
	barberSem = createSemaphore(0);
	mutex = createSemaphore(1);
	waiting = 0;

	// Initialize the numbers array.
    for (i=0; i<NUM_CUSTOMERS; i++) {
		Number[i] = i;
    }    
	// Create the barber.
	for(i = 0; i < NUM_BARBERS; i++) {
		printf("Creating barber %d\n", i);
		fflush(stdout);
		pthread_create(&barb[i], NULL, barber, (void *)Number[i]);
	
	}    
	// Create the customers.
    for (i=0; i<NUM_CUSTOMERS; i++) {
		printf("Customer %d walks into the barber shop\n", i);
		fflush(stdout);
		pthread_create(&customers[i], NULL, customer, (void *)Number[i]);
	}
	usleep(1000000);
	// C // Cr // Join each of the threads to wait for them to finish	
    for (i=0; i<NUM_CUSTOMERS; i++) {
		pthread_cancel(customers[i]);
//		pthread_cleanup_push(cleanUp, customerSem);
 		pthread_join(customers[i],NULL);
    }
	for (i=0; i<NUM_BARBERS; i++) {
		printf("Barber %d is leaving\n", i);
		fflush(stdout);
		pthread_cancel(barb[i]);
//		pthread_cleanup_push(cleanUp, barberSem);
		pthread_join(barb[i],NULL);
    }
//	exit(0);
	return 0;
}
