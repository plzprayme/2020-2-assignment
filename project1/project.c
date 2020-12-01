#include <pthread.h>
#include <stdio.h>
#define ITER 11
void *thread_increment(void *arg);
void *thread_decrement(void *arg);
int x;
pthread_mutex_t m;
// pthread_cond_t is_full;
pthread_cond_t producer;
pthread_cond_t consumer;
int main() {
  pthread_t tid1, tid2;      // pthread id
  // pthread_cond_init(&is_full, NULL);
  pthread_cond_init(&producer,NULL); // init pthread_cond_t 
  pthread_cond_init(&consumer,NULL); // init pthread_cond_t 
  pthread_mutex_init(&m, NULL);           // sync
  pthread_create(&tid1, NULL, thread_increment, NULL);
  pthread_create(&tid2, NULL, thread_decrement, NULL);
  pthread_join(tid1, NULL); // delay until exit tid1
  pthread_join(tid2, NULL); // prevent exit main thread until exit created thread

  if (x != 0)
    printf("BOOM! counter=%d\n", x);
  else
    printf("OK counter=%d\n", x);

  pthread_mutex_destroy(&m);            // garbage collect
  //pthread_cond_destroy(&is_full);
  pthread_cond_destroy(&producer); // garbage collect
  pthread_cond_destroy(&consumer); // garbage collect
  
  return 0;
}

void * thread_increment (void *arg) {
  int i, val;
  for (i=0; i<ITER; i++) {
    pthread_mutex_lock(&m); // lock
    val = x;
    printf("%u:%d\n", (unsigned int) pthread_self(), val);
    

    if (x == 10) {
      pthread_cond_signal(&consumer);
    }

    printf("WHERE ARE YOU");
    while (x==10) {
      pthread_cond_wait(&producer, &m);
      printf("PRODUCER IS STOPPED\n");
      printf("producer x:%d\n", x);
    }


   // if (x == 0) {
    //  pthread_cond_signal(&is_full);
     // printf("HELLO2\n");
    //}

    //while (x == 10) {
     // pthread_cond_signal(&consumer);
     // pthread_cond_wait(&is_full, &m);
      //printf("HELLO\n");
    //}


    //if (x==999999999) {
      //pthread_cond_signal(&consumer);
      //pthread_cond_wait(&producer, &m);
      //printf("HELLO");
    //}



    x = val + 1;
    pthread_mutex_unlock(&m); // unlock
  }
  pthread_exit(NULL);
}

void * thread_decrement (void *arg) {
  int i, val;
  for (i=0; i<ITER; i++) {
    pthread_mutex_lock(&m); // lock

    val = x;
    printf("%u:%d\n", (unsigned int) pthread_self(), val);
    
    if (x == 0){
      pthread_cond_signal(&producer);
    }


    while(x==0) {
      pthread_cond_wait(&consumer, &m);
      printf("consumer x: %d\n", x);
    }

   // if (x == 10) {
     // pthread_cond_signal(&is_full);
     // printf("BYE2\n");
    //}

    //while (x == 0) {
      //pthread_cond_signal(&producer);
     // pthread_cond_wait(&is_full,&m);
      //printf("BYE\n");
   // }

    //if (x==99999) {
      //pthread_cond_signal(&producer);
      //pthread_cond_wait(&consumer, &m);
      //printf("BYE");
    //}


    x = val - 1;
    pthread_mutex_unlock(&m); // unlock
  }
  pthread_exit(NULL);
}
