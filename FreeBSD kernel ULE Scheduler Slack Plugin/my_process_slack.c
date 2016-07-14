/*********************** Operating System Course *****************
******************************** Project *************************
****************************** Winter 2012 **********************
****************************** Dr. Jalili ***********************
************************** my_process_slack.c *********************
******************************************************************/

#include <sys/param.h>
#include <sys/proc.h>
#include <sys/module.h>
#include <sys/sysproto.h>
#include <sys/sysent.h>
#include <sys/kernel.h>
#include <sys/systm.h>
#include <sys/lock.h>
#include <sys/mutex.h>
// sched.h
#include <sys/sched.h>

struct my_procces_slack_args{
	int pid;
	struct timeval wcet;
	struct timeval deadline;
	int func;	// 1 for set_process_slack; 2 for get_process_slack; 3 for disable_process_slack
};

static int my_process_slack(struct thread *td, struct my_procces_slack_args *args)
{
	int f = (int)args->func;
	if(f == 1)
	{
		struct timeval WCET_here;
		struct timeval deadline_here;

		printf("before copyin\n");
		copyin( &(((struct my_procces_slack_args*)args)->wcet), (void*)(&WCET_here), sizeof(struct timeval) );
		copyin( &(((struct my_procces_slack_args*)args)->deadline), (void*)(&deadline_here), sizeof(struct timeval) );

		printf("WCET is: %d\n", (int)(WCET_here.tv_sec));
	
		printf("p is: %d\n", ((struct my_procces_slack_args*)args)->pid );
	
		printf("before pfind\n");
		struct proc *p = pfind( ((struct my_procces_slack_args*)args)->pid);

		printf("before assert\n");
		PROC_LOCK_ASSERT(p, MA_OWNED);
	
		printf("before FIRST_THREAD_...\n");
		struct thread* target_thread=FIRST_THREAD_IN_PROC(p);

		printf("before set_thread_slack\n");
		set_thread_slack(target_thread, &WCET_here, &deadline_here );

		printf("before PROC_UNLOCK\n");
		PROC_UNLOCK(p);

		printf("before return\n");
		return 0;
	}
	else if (f == 2)
	{
		struct timeval WCET_here;
		struct timeval deadline_here;

		printf("get:before pfind\n");
		struct proc *p = pfind(((struct my_procces_slack_args*)args)->pid);

		printf("get:before PROC_LOCK_ASSERT\n");
		PROC_LOCK_ASSERT(p, MA_OWNED);
	
		printf("get:before FIREST_THREAD_...\n");
		struct thread* target_thread = FIRST_THREAD_IN_PROC(p);
	
		printf("get:before get_thread_slack\n");
		get_thread_slack(target_thread, &WCET_here, &deadline_here );

	
		((struct my_procces_slack_args*)args)->wcet.tv_sec = WCET_here.tv_sec;
		((struct my_procces_slack_args*)args)->wcet.tv_usec = WCET_here.tv_usec;

		((struct my_procces_slack_args*)args)->deadline.tv_sec = deadline_here.tv_sec;
		((struct my_procces_slack_args*)args)->deadline.tv_usec = deadline_here.tv_usec;

		printf("get:before PROC_UNLOCK\n");
		PROC_UNLOCK(p);

		printf("get:before return\n");
		return 0;

	}
	else if (f == 3)
	{
		struct proc *p = pfind(((struct my_procces_slack_args*)args)->pid);
	
		PROC_LOCK_ASSERT(p, MA_OWNED);

		struct thread* target_thread = FIRST_THREAD_IN_PROC(p);

		disable_thread_slack(target_thread);
	
		PROC_UNLOCK(p);

		return 0;
	}
	else if(f > 3 || f < 1)
	{
		printf("error in function number...\n");
	}
	return 0;
}

static struct sysent my_process_slack_sysent =
{
	sizeof(struct my_procces_slack_args)/4 , // The Number of byte in the arguments
	(sy_call_t*) my_process_slack
};

static int offset = NO_SYSCALL;

static int load(struct module *module, int cmd, void *arg)
{
	int error = 0;
	switch (cmd) {
	case MOD_LOAD :
		printf("New syscall has been loaded.\n");
		printf("offset : %d\n", offset);
		break;
	case MOD_UNLOAD :
		printf("New syscall has been unloaded.\n");
		printf("offset : %d\n", offset);
		break;
	default :
		error = EOPNOTSUPP;
		break;
	}
	return (error);
}

SYSCALL_MODULE(my_process_slack, &offset, &my_process_slack_sysent, load, NULL);
