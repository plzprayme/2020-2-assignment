#include <pthread.h>
#include <stdio.h>
#define ITER 10
#define PRODUCER_ITER ITER * 8 + 1
#define CONSUMER_ITER ITER * 10
void *thread_increment(void *arg);
void *thread_decrement(void *arg);
int x = -1; 
pthread_mutex_t m;
pthread_cond_t count_nonzero;
int main() {

  // input ITER NUMS, produce NUMS
  pthread_t tid1, tid2;
  pthread_cond_init(&count_nonzero, NULL);
  pthread_mutex_init(&m, NULL);

  pthread_create(&tid1, NULL, thread_increment, NULL);
  pthread_create(&tid2, NULL, thread_decrement, NULL);
  
  pthread_join(tid1, NULL);
  pthread_join(tid2, NULL);

  if (x < 0 || x > 20)
    printf("ERROR! counter=%d\n", x);
  else
    printf("OK counter=%d\n", x);
  
  pthread_mutex_destroy(&m);
  pthread_cond_destroy(&count_nonzero);
  
  return 0;
}

void * thread_increment (void *arg) {
  int i, val;
  x = 1;
  for (i=0; i<50; i++) {
    pthread_mutex_lock(&m);
    
    if (x==20) {
      pthread_cond_signal(&count_nonzero);
      pthread_cond_wait(&count_nonzero, &m);
      x = 2;
    }

    val = x;
    printf("Producer>> %u:%d\n", (unsigned int) pthread_self(), val);

    x = val + 1;
    pthread_mutex_unlock(&m);
  }
  pthread_cond_signal(&count_nonzero);
  pthread_exit(NULL);
}

void * thread_decrement (void *arg) {
  int i, val;
  for (i=0; i<50; i++) {
    pthread_mutex_lock(&m);

    if (x<1) {
      pthread_cond_signal(&count_nonzero);
      pthread_cond_wait(&count_nonzero, &m);
    }


    val = x;
    printf("Consumer<< %u:%d\n", (unsigned int) pthread_self(), val);
    x = val - 1;
    pthread_mutex_unlock(&m);
  }
  pthread_exit(NULL);
}
