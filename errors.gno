package zentasktic_user

import "errors"

var (
	ErrWorkDurationNotFound             	= errors.New("Could not find work duration")
	ErrWorkDurationNotRemoved           	= errors.New("Could not remove work duration")
	ErrWorkDurationsEmpty		           	= errors.New("There are no work durations registered")
	ErrWorkDurationIdAlreadyExists			= errors.New("Work duration id already exists")
	ErrUserIdAlreadyExists					= errors.New("User id already exists")
	ErrUserIdNotFound						= errors.New("User id not found")
	ErrUserNotRemoved						= errors.New("User was not removed")
	ErrUserTasksIncorrectType				= errors.New("Incorrect type for UserTasks")
	ErrUserProjectsIncorrectType			= errors.New("Incorrect type for UserProjects")
	ErrUserTasksNotFound					= errors.New("Could not find user tasks")
	ErrUserTasksNotRemoved					= errors.New("User tasks could not be removed")
	ErrUserProjectsNotRemoved				= errors.New("User projects could not be removed")
	ErrUserProjectsNotFound					= errors.New("Could not find user projects")
	ErrPaymentIdAlreadyExists				= errors.New("A payment entry with the same id already exists")
	ErrPaymentIdNotFound					= errors.New("A payment with this id could not be found")
	ErrPaymentNotRemoved					= errors.New("The payment entry was not removed")
	
)