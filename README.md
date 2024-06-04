# ZenTasktic User

A custom implementation of ZenTasktic Core as `r/zentasktic_user` which can be used for self-management by an individual - it includes a minimal set of different data types than the ones defined in `r/zentasktic_project`. It is intended as an example for further extension of the core package.

## Data types

There are 2 new data types defined: `User` and `Payment`. They can be seen as the counterparts of `Actor` and `RewardsPoint` in `r/zentasktic_project`.

```
type User struct {
	Id 		    	string `json:"userId"`
	Name 		    string `json:"userName"`
	Address			std.Address	`json:"userAddress"`
}
```

```
type Payment struct {
    Id				string `json:"paymentId"`
    ObjectId 		string `json:"objectId"`
    ObjectType      string `json:"objectType"`
	Amount  		std.Coins `json:"paymentAmount"`
    Status			string `json:"paymentStatus"`            // invoiced / paid, etc
}
```

We reuse `WorkDuration` implementation from `r/zentasktic_project`, so if you worked with it before, it should be familiar.

We are also wrapping the `p/zentasktic` package functions, so they are transparently available in the realm, all related code is in `wrapper.gno`.

## Example Workflow

This is an example on how to use the implementation in a new realm.

```
package myzentodo

import (
	"fmt"
	"gno.land/r/demo/zentasktic_user"
)

func main() {
	// Create a new user
	user := zentasktic_user.User{
		Id:   "user-1",
		Name: "John Doe",
		Address: "g1fptq8jnypzm4udqd6d8luja5w44js4jqncdg9g",
	}

	// Add the user
	err := user.AddUser()
	if err != nil {
		fmt.Println(err)
		return
	}

	// Assign the user to a task
	task := zentasktic_user.WorkableTask{
		Id:   "task-1",
		Name: "Task 1",
	}
	err = user.AssignUserToTask(&task)
	if err != nil {
		fmt.Println(err)
		return
	}

	// Assign the user to a project
	project := zentasktic_user.WorkableProject{
		Id:   "project-1",
		Name: "Project 1",
	}
	err = user.AssignUserToProject(&project)
	if err != nil {
		fmt.Println(err)
		return
	}

	// Get all users
	users, err := GetAllUsers()
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(users)

	// Get user tasks
	tasks, err := user.GetUserTasks()
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(tasks)

	// Get user projects
	projects, err := user.GetUserProjects()
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(projects)
}

```