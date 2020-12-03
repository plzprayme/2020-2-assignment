#include <pthread.h>
#include <stdio.h>
#define ITER 10
void *thread_increment(void *arg);
void *thread_decrement(void *arg);
int x;
pthread_mutex_t m;
pthread_cond_t count_nonzero;
int main() {
  pthread_t tid1, tid2;                   // pthread id
  pthread_cond_init(&count_nonzero,NULL); // init pthread_cond_t 
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
  pthread_cond_destroy(&count_nonzero); // garbage collect
  
  return 0;
}

void * thread_increment (void *arg) {
  int i, val;
  for (i=1; i<ITER; i++) {
    pthread_mutex_lock(&m); // lock
    val = x;
    printf("%u:%d\n", (unsigned int) pthread_self(), val);
    if (x==0)
      pthread_cond_signal(&count_nonzero); // unlock
    x = val + 1;
    pthread_mutex_unlock(&m); // unlock
  }
  pthread_exit(NULL);
}

void * thread_decrement (void *arg) {
  int i, val;
  for (i=1; i<ITER; i++) {
    pthread_mutex_lock(&m); // lock
    while (x==0)
      pthread_cond_wait(&count_nonzero, &m); // lock
    val = x;
    printf("%u:%d\n", (unsigned int) pthread_self(), val);
    x = val - 1;
    pthread_mutex_unlock(&m); // unlock
  }
  pthread_exit(NULL);
}
