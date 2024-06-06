package zentasktic_user

import (
	"strconv"
	"errors"
	"std"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/zentasktic"
)

type User struct {
	Id 		    	string `json:"userId"`
	Name 		    string `json:"userName"`
	Address			std.Address	`json:"userAddress"`
}

var (
	Users avl.Tree // u.Id -> u
	UserTasks avl.Tree // u.Id -> []*WorkableTask
	UserProjects avl.Tree // u.Id -> []*WorkableProject
)

func (u User) AddUser() (err error) { 
	// implementation
	
	if Users.Size() != 0 {
		existingUser, exist := Users.Get(u.Id)
		if exist {
			return ErrUserIdAlreadyExists
		}
	}
	Users.Set(u.Id, u)
	return nil

}

func (u User) RemoveUser() (err error) {
	// implementation
	existingUser := User{}
	if Users.Size() != 0 {
		existingUser, exist := Users.Get(u.Id)
		if !exist {
			return ErrUserIdNotFound
		}
	}
	
	// if user has tasks assigned, unassign from them
	if UserTasks.Size() != 0 {
		existingUserTasks, exist := UserTasks.Get(u.Id)
		if exist {
			_, removed := UserTasks.Remove(u.Id)
			if !removed {
				return ErrUserTasksNotRemoved
			}
		}
	}

	// if user has projects assigned, unassign from them
	if UserProjects.Size() != 0 {
		existingUserProjects, exist := UserProjects.Get(u.Id)
		if exist {
			_, removed := UserProjects.Remove(u.Id)
			if !removed {
				return ErrUserProjectsNotRemoved
			}
		}
	}

	// remove actor
	_, removed := Users.Remove(u.Id)
	if !removed {
		return ErrUserNotRemoved
	}
	return nil

}

func (u User) EditUser() (err error) {
	// implementation, get user by Id and replace the object
	existingUser := User{}
	if Users.Size() != 0 {
		existingUser, exist := Users.Get(u.Id)
		if !exist {
			return ErrUserIdNotFound
		}
	}
	
	Users.Set(u.Id, u)
	return nil
}

func (u User) AssignUserToTask(wt *WorkableTask) error {
    if UserTasks.Size() != 0 {
        existingWorkableTasks, ok := UserTasks.Get(u.Id)
        if !ok {
            existingWorkableTasks = []*WorkableTask{}
        }
        
        tasks, ok := existingWorkableTasks.([]*WorkableTask)
        if !ok {
            return ErrUserTasksNotFound
        }
        
        updatedTasks := append(tasks, wt)
        UserTasks.Set(u.Id, updatedTasks)
    } else {
        UserTasks.Set(u.Id, []*WorkableTask{wt})
    }
    return nil
}

func (u User) UnassignUserFromTask(wt *WorkableTask) error {
    if UserTasks.Size() != 0 {
        existingUserTasks, exist := UserTasks.Get(u.Id)
        if !exist {
            return ErrUserTasksNotFound
        }

        tasks, ok := existingUserTasks.([]*WorkableTask)
        if !ok {
            return ErrUserTasksNotFound
        }

        var tindex int = -1
        for i, task := range tasks {
            if wt.Id == task.Id {
                tindex = i
                break
            }
        }

        if tindex != -1 {
            updatedTasks := append(tasks[:tindex], tasks[tindex+1:]...)
            UserTasks.Set(u.Id, updatedTasks)
        } else {
            return ErrUserTasksNotFound
        }
    } else {
        return ErrUserTasksNotFound
    }
    return nil
}

func (u User) AssignUserToProject(wp *WorkableProject) (err error) {
	if UserProjects.Size() != 0 {
        existingWorkableProjects, ok := UserProjects.Get(u.Id)
        if !ok {
            existingWorkableProjects = []*WorkableProject{}
        }
        
        projects, ok := existingWorkableProjects.([]*WorkableProject)
        if !ok {
            return ErrUserProjectsNotFound
        }
        
        updatedProjects := append(projects, wp)
        UserProjects.Set(u.Id, updatedProjects)
    } else {
        UserProjects.Set(u.Id, []*WorkableProject{wp})
    }
    return nil
} 

func (u User) UnassignUserFromProject(wp *WorkableProject) error {
    if UserProjects.Size() != 0 {
        existingUserProjects, exist := UserProjects.Get(u.Id)
        if !exist {
            return ErrUserProjectsNotFound
        }

        projects, ok := existingUserProjects.([]*WorkableProject)
        if !ok {
            return ErrUserProjectsNotFound
        }

        var tindex int = -1
        for i, project := range projects {
            if wp.Id == project.Id {
                tindex = i
                break
            }
        }

        if tindex != -1 {
            updatedProjects := append(projects[:tindex], projects[tindex+1:]...)
            UserProjects.Set(u.Id, updatedProjects)
        } else {
            return ErrUserProjectsNotFound
        }
    } else {
        return ErrUserProjectsNotFound
    }
    return nil
}


// getters

func GetUserById(userId string) (u User, err error) {
	if Users.Size() != 0 {
		user, exist := Users.Get(userId)
		if exist {
			return user.(User), nil
		} else {
			return nil, ErrUserIdNotFound
		}

	}
	return nil, ErrUserIdNotFound
}

func GetAllUsers()(users string, err error) {
	// implementation
	var allUsers []User

	// Iterate over the Users AVL tree to collect all Actor objects.
	Users.Iterate("", "", func(key string, value interface{}) bool {
		if user, ok := value.(User); ok {
			allUsers = append(allUsers, user)
		}
		return false // Continue iteration until all nodes have been visited.
	})

	// Create a UsersObject with all collected Users.
	usersObject := &UsersObject{
		Users: allUsers,
	}

	// Use the custom MarshalJSON method to marshal the Users into JSON.
	marshalledUsers, merr := usersObject.MarshalJSON()
	if merr != nil {
		return "", merr
	} 
	return string(marshalledUsers), nil
}

func (u User) GetUserTasks() (userTasks string, err error) {
	if UserTasks.Size() != 0 {
		existingWorkableTasks, exist := UserTasks.Get(u.Id)
		if !exist {
			return "", ErrUserTasksNotFound
		}

		// Perform a type assertion to convert interface{} to []*WorkableTask.
		tasksPtrs, ok := existingWorkableTasks.([]*WorkableTask)
		if !ok {
			return "", ErrUserTasksIncorrectType
		}

		// Convert []*WorkableTask to []Task
		tasks := make([]zentasktic.Task, len(tasksPtrs))
		for i, wt := range tasksPtrs {
			tasks[i] = wt.Task 
		}

		// Check if there are actually any tasks in the slice.
		if len(tasks) == 0 {
			return "", ErrUserTasksNotFound
		}

		// Create a TasksObject and marshal into JSON
		tasksObject := zentasktic.TasksObject{Tasks: tasks}
		marshaledTasks, err := tasksObject.MarshalJSON()
		if err != nil {
			return "", err 
		}

		// Return the JSON string and nil error on success.
		return string(marshaledTasks), nil
	}

	return "", ErrUserTasksNotFound
}

func (u User) GetUserProjects() (userProjects string, err error) {
	if UserProjects.Size() != 0 {
		existingWorkableProjects, exist := UserProjects.Get(u.Id)
		if !exist {
			return "", ErrUserProjectsNotFound
		}

		// Perform a type assertion to convert interface{} to []*WorkableProject.
		projectPtrs, ok := existingWorkableProjects.([]*WorkableProject)
		if !ok {
			return "", ErrUserProjectsIncorrectType
		}

		// Convert []*WorkableProject to []Project
		projects := make([]zentasktic.Project, len(projectPtrs))
		for i, wp := range projectPtrs {
			projects[i] = wp.Project 
		}

		// Check if there are actually any projects in the slice.
		if len(projects) == 0 {
			return "", ErrUserProjectsNotFound
		}

		// Create a ProjectsObject and marshal into JSON
		projectsObject := zentasktic.ProjectsObject{Projects: projects}
		marshaledProjectss, err := projectsObject.MarshalJSON()
		if err != nil {
			return "", err 
		}

		// Return the JSON string and nil error on success.
		return string(marshaledProjectss), nil
	}

	return "", ErrUserProjectsNotFound
}