#include <stdio.h>						  
#include <stdlib.h>  
#include <errno.h>						  
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>
#include <syslog.h>

#define DAEMON_NAME "itvision"
#define PID_FILE "/var/run/itvision.pid"
 
/**************************************************************************
    Function: Print Usage
 
    Description:
        Output the command-line options for this daemon.
 
    Params:
        @argc - Standard argument count
        @argv - Standard argument array
 
    Returns:
        returns void always
**************************************************************************/
void PrintUsage(int argc, char *argv[]) {
    if (argc >=1) {
        printf("Usage: %s -h -n\n", argv[0]);
        printf("  Options:\n");
        printf("      -n\tDon't fork off as a daemon.\n");
        printf("      -h\tShow this help screen.\n");
        printf("\n");
    }
}
 
/**************************************************************************
    Function: signal_handler
 
    Description:
        This function handles select signals that the daemon may
        receive.  This gives the daemon a chance to properly shut
        down in emergency situations.  This function is installed
        as a signal handler in the 'main()' function.
 
    Params:
        @sig - The signal received
 
    Returns:
        returns void always
**************************************************************************/
void signal_handler(int sig) {
 
    switch(sig) {
        case SIGHUP:
            syslog(LOG_WARNING, "Received SIGHUP signal.");
            break;
        case SIGTERM:
            syslog(LOG_WARNING, "Received SIGTERM signal.");
            break;
        default:
            syslog(LOG_WARNING, "Unhandled signal (%d) %s", strsignal(sig));
            break;
    }
}
 
/**************************************************************************
    Function: main
 
    Description:
        The c standard 'main' entry point function.
 
    Params:
        @argc - count of command line arguments given on command line
        @argv - array of arguments given on command line
 
    Returns:
        returns integer which is passed back to the parent process
**************************************************************************/
int main(int argc, char *argv[]) {

    int daemonize = 1;
	int c;
	while( (c = getopt(argc, argv, "nh|help")) != -1) {
		switch(c) {
		case 'h':
			PrintUsage(argc, argv);
			exit(0);
			break;
		case 'n':
			daemonize = 0;
			break;
		default:
			PrintUsage(argc, argv);
			exit(0);
			break;
		}
	}
	
    // Setup signal handling before we start
    signal(SIGHUP, signal_handler);
    signal(SIGTERM, signal_handler);
    signal(SIGINT, signal_handler);
    signal(SIGQUIT, signal_handler);
 
    if (daemonize) {
    	syslog(LOG_INFO, "%s daemon starting up", DAEMON_NAME);
 
		pid_t  pid, sid;
	
		/* Fork off the parent process */
		pid = fork();
	
		/* If pid < 0 Error in fork */								 
		if (pid < 0) {
			fprintf(stderr, "Error in fork\n");
			exit(EXIT_FAILURE);  
		}  
	
		/* Forcing the exit of parent process */
		if (pid > 0) {
			exit(EXIT_SUCCESS);
		}     
	
    	/* Child process from  here */   
	
    	/* System logger here */
	
		/* Change the file mode mask */
		umask(0);
	
	 	/* Create new sid for the child process */
		sid = setsid();
		if  (sid < 0) {  
			fprintf(stderr, "Error in setsid\n"); 
			exit(EXIT_FAILURE);
		}
   
		/* Changing the working directory to root directory */
		if (chdir("/") < 0) {
			fprintf(stderr, "Error change direcory\n");
			exit(EXIT_FAILURE);
		}
   
		/* Close the standard file descriptor (STDIN, STDOUT, STDERR) */ 
		close(STDIN_FILENO);
		close(STDOUT_FILENO); 
		close(STDERR_FILENO);
	}
   
	/* Infinite loop */				 
	while (1) { 
		/* YOUR CODE HERE */
	}
    
    syslog(LOG_INFO, "%s daemon exiting", DAEMON_NAME);
    exit(EXIT_SUCCESS);
}   

