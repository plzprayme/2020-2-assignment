#include <pthread.h>
#include <stdio.h>

void *thread_increment(void *arg);
void *thread_decrement(void *arg);

pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t count_nonzero = PTHREAD_COND_INITIALIZER;
int x = -1; 

void main() {

  int iter_nums;
  int *p = &iter_nums;
  printf("<< input iter nums: ");
  scanf("%d", &iter_nums);

  pthread_t tid1, tid2;
  pthread_create(&tid1, NULL, thread_increment, p);
  pthread_create(&tid2, NULL, thread_decrement, p);
  
  pthread_join(tid1, NULL);
  pthread_join(tid2, NULL);

  if (x < 0 || x > 10)
    printf("ERROR! counter=%d\n", x);
  else
    printf("OK counter=%d\n", x);
  
  pthread_mutex_destroy(&m);
  pthread_cond_destroy(&count_nonzero);
}

void * thread_increment (void *arg) {
  int i; x = 1;
  for (i=0; i<*(int*)arg; i++) {
    pthread_mutex_lock(&m);
    
    if (x==10) {
      pthread_cond_signal(&count_nonzero);
      pthread_cond_wait(&count_nonzero, &m);
      x=2;
    }

    printf(">> Producer|%u::%d\n", (unsigned int) pthread_self(), x);

    ++x;
    pthread_mutex_unlock(&m);
  }
  pthread_cond_signal(&count_nonzero);
  pthread_exit(NULL);
}

void * thread_decrement (void *arg) {
  int i;
  for (i=0; i<*(int*)arg; i++) {
    pthread_mutex_lock(&m);

    if (x<1) {
      pthread_cond_signal(&count_nonzero);
      pthread_cond_wait(&count_nonzero, &m);
    }

    printf("<< Consumer|%u::%d\n", (unsigned int) pthread_self(), x);
    --x;
    pthread_mutex_unlock(&m);
  }
  pthread_cond_signal(&count_nonzero);
  pthread_exit(NULL);
}
