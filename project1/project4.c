#include <pthread.h>
#include <stdio.h>
#define ITER 1000
void *thread_increment(void *arg);
void *thread_decrement(void *arg);
int x = -1; 
pthread_mutex_t m;
pthread_cond_t count_nonzero;
int main() {
  pthread_t tid1, tid2;
  pthread_cond_init(&count_nonzero, NULL);
  pthread_mutex_init(&m, NULL);
  pthread_create(&tid1, NULL, thread_increment, NULL);
  pthread_create(&tid2, NULL, thread_decrement, NULL);
  pthread_join(tid1, NULL);
  pthread_join(tid2, NULL);

  if (x != 0)
    printf("BOOM! counter=%d\n", x);
  else
    printf("OK counter=%d\n", x);
  pthread_mutex_destroy(&m);
  pthread_cond_destroy(&count_nonzero);
  return 0;
}

void * thread_increment (void *arg) {
  int i, val;
  for (i=1; i<ITER; i++) {
    pthread_mutex_lock(&m);
    

    if (x==-1) {
      pthread_cond_signal(&count_nonzero);
      x = 1;
    }


    if (x==10) {
      pthread_cond_signal(&count_nonzero);
    while (x==10) {
      printf("I'm WAITING FOR YOU");
      pthread_cond_wait(&count_nonzero, &m); 
      printf("I'm OUT FOR YOU");
      //pthread_mutex_unlock(&m);
      //pthread_exit(NULL);
    }
    continue;
    }

    val = x;
    printf("%u:%d\n", (unsigned int) pthread_self(), val);
    
    x = val + 1;
    pthread_mutex_unlock(&m);
  }
  pthread_exit(NULL);
}

void * thread_decrement (void *arg) {
  int i, val;
  for (i=0; i<ITER; i++) {
    pthread_mutex_lock(&m);
    printf("HELLOL");

    while (x==-1) {
      pthread_cond_wait(&count_nonzero, &m);
    }

    val = x;
    printf("%u:%d\n", (unsigned int) pthread_self(), val);

    printf("WHY?%d\n", x);
    if (x==1) {
	  printf("HERE?");
      pthread_cond_signal(&count_nonzero);
      printf("OR HERE");
      while (x==1) {
	printf("I'm WAITING FOR ME");
        pthread_cond_wait(&count_nonzero, &m);
	printf("I'm OUT FOR ME");
      }
      continue;
      //pthread_mutex_unlock(&m);
      //pthread_exit(NULL);
    }

    x = val - 1;
    pthread_mutex_unlock(&m);
  }
  pthread_exit(NULL);
}
