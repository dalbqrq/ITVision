--
-- The definitions in this file was extracted from "nagios.h" file located
-- in Nagios version 3.0.3 source code (nagios-3.0.3/src/base)
-- 
-- Definitions of "pending" hosts and services was included to fit the requirements
-- of IT Vision software.
--
--------------------- APPLICATION STATUS (Only for IT Vision) --------------------

APPLIC_UP					= 0
APPLIC_DOWN					= 1
APPLIC_WARNING				= 2
APPLIC_PENDING				= 3

--------------------- HOST STATUS --------------------

HOST_UP 					= 0
HOST_DOWN 					= 1
HOST_UNREACHABLE 			= 2
HOST_PENDING	 			= 3	-- Only for IT Vision 


-------------------- STATE LOGGING TYPES -------------

INITIAL_STATES 				= 1
CURRENT_STATES 				= 2


------------- SERVICE DEPENDENCY VALUES --------------

DEPENDENCIES_OK 			= 0
DEPENDENCIES_FAILED 		= 1


------------ ROUTE CHECK PROPAGATION TYPES -----------

PROPAGATE_TO_PARENT_HOSTS 	= 1
PROPAGATE_TO_CHILD_HOSTS 	= 2


------------------- SERVICE STATES -------------------

STATE_OK 					= 0
STATE_WARNING 				= 1
STATE_CRITICAL 				= 2
STATE_UNKNOWN 				= 3
STATE_PENDING 				= 4 -- Only for IT Vision


------------------- FLAPPING TYPES -------------------

HOST_FLAPPING 				= 0
SERVICE_FLAPPING 			= 1



----------------- NOTIFICATION TYPES -----------------

HOST_NOTIFICATION 			= 0
SERVICE_NOTIFICATION 		= 1


-------------- NOTIFICATION REASON TYPES --------------

NOTIFICATION_NORMAL 			= 0
NOTIFICATION_ACKNOWLEDGEMENT 	= 1
NOTIFICATION_FLAPPINGSTART 		= 2
NOTIFICATION_FLAPPINGSTOP 		= 3
NOTIFICATION_FLAPPINGDISABLED 	= 4
NOTIFICATION_DOWNTIMESTART 		= 5
NOTIFICATION_DOWNTIMEEND 		= 6
NOTIFICATION_DOWNTIMECANCELLED 	= 7
NOTIFICATION_CUSTOM 			= 99


----------------- EVENT HANDLER TYPES ----------------

HOST_EVENTHANDLER				= 0
SERVICE_EVENTHANDLER			= 1
GLOBAL_HOST_EVENTHANDLER		= 2
GLOBAL_SERVICE_EVENTHANDLER		= 3


------------------ STATE CHANGE TYPES ----------------

HOST_STATECHANGE				= 0
SERVICE_STATECHANGE				= 1



------------------ OBJECT CHECK TYPES ----------------
SERVICE_CHECK					= 0
HOST_CHECK						= 1


-------------------- EVENT TYPES ---------------------

EVENT_SERVICE_CHECK 			= 0			-- active service check 
EVENT_COMMAND_CHECK 			= 1			-- external command check 
EVENT_LOG_ROTATION 				= 2			-- log file rotation 
EVENT_PROGRAM_SHUTDOWN 			= 3			-- program shutdown 
EVENT_PROGRAM_RESTART 			= 4			-- program restart 
EVENT_CHECK_REAPER 				= 5			-- reaps results from host and service checks 
EVENT_ORPHAN_CHECK 				= 6			-- checks for orphaned hosts and services 
EVENT_RETENTION_SAVE 			= 7			-- save (dump) retention data 
EVENT_STATUS_SAVE 				= 8			-- save (dump) status data 
EVENT_SCHEDULED_DOWNTIME 		= 9			-- scheduled host or service downtime 
EVENT_SFRESHNESS_CHECK 			= 10		-- checks service result "freshness" 
EVENT_EXPIRE_DOWNTIME 			= 11		-- checks for (and removes) expired scheduled downtime 
EVENT_HOST_CHECK 				= 12		-- active host check 
EVENT_HFRESHNESS_CHECK 			= 13		-- checks host result "freshness" 
EVENT_RESCHEDULE_CHECKS 		= 14		-- adjust scheduling of host and service checks 
EVENT_EXPIRE_COMMENT 			= 15		-- removes expired comments 
EVENT_SLEEP 					= 98		-- asynchronous sleep event that occurs when event queues are empty 
EVENT_USER_FUNCTION 			= 99		-- USER-defined function (modules) 


-------- INTER-CHECK DELAY CALCULATION TYPES ---------

ICD_NONE 			= 0				-- no inter-check delay 
ICD_DUMB 			= 1				-- dumb delay of 1 second 
ICD_SMART 			= 2				-- smart delay 
ICD_USER 			= 3				-- user-specified delay 


-------- INTERLEAVE FACTOR CALCULATION TYPES ---------

ILF_USER 			= 0				-- user-specified interleave factor 
ILF_SMART 			= 1				-- smart interleave 


------------- SCHEDULED DOWNTIME TYPES ---------------

ACTIVE_DOWNTIME 	= 0				-- active downtime - currently in effect 
PENDING_DOWNTIME 	= 1				-- pending downtime - scheduled for the future 

