package zentasktic_user


import (
	"strconv"
	"errors"
	"std"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/zentasktic"
)

// this is a convenience wrapper on top of the functions declared in the zentasktic package
// to maintain consistency

// wrapping zentasktic types
type WorkableRealm struct {
	Id   string
	Name string
}

type WorkableContext struct {
	Id   string
	Name string
}

type WorkableCollection struct {
	Id       string
	RealmId  string
	Name     string
	Tasks    []WorkableTask
	Projects []WorkableProject
}

type WorkableObjectPath struct {
	ObjectType string
	Id         string
	RealmId    string
}

// zentasktic managers

var ztm *zentasktic.ZTaskManager
var zpm *zentasktic.ZProjectManager
var zrm *zentasktic.ZRealmManager
var zcm *zentasktic.ZContextManager
var zcl *zentasktic.ZCollectionManager
var zom *zentasktic.ZObjectPathManager

func init() {
    ztm = zentasktic.NewZTaskManager()
    zpm = zentasktic.NewZProjectManager()
	zrm = zentasktic.NewZRealmManager()
	zcm = zentasktic.NewZContextManager()
	zcl = zentasktic.NewZCollectionManager()
	zom = zentasktic.NewZObjectPathManager()
}

// tasks

func AddTask(wt *WorkableTask) error {
	return ztm.AddTask(wt.Task)
}

func EditTask(wt *WorkableTask) error {
	return ztm.EditTask(wt.Task)
}

func RemoveTask(wt *WorkableTask) error {
	return ztm.RemoveTask(wt.Task)
}

func MoveTaskToRealm(taskId string, realmId string) error {
	return ztm.MoveTaskToRealm(taskId, realmId)
}

func SetTaskDueDate(taskId string, dueDate string) error {
	return ztm.SetTaskDueDate(taskId, dueDate)
}

func SetTaskAlert(taskId string, alert string) error {
	return ztm.SetTaskAlert(taskId, alert)
}

func AttachTaskToProject(ztm *zentasktic.ZTaskManager, wt *WorkableTask, wp *WorkableProject) error {
	return zpm.AttachTaskToProject(ztm, wt.Task, wp.Project)
}

func DetachTaskFromProject(ztm *zentasktic.ZTaskManager, wt *WorkableTask, wp *WorkableProject) error {
	return zpm.DetachTaskFromProject(ztm, wt.Task, wp.Project)
}

func GetTaskById(taskId string) (WorkableTask, error) {
	task, err := ztm.GetTaskById(taskId)
	if err != nil {
		return WorkableTask{}, err
	}
	return WorkableTask{Task: task}, nil
}

func GetAllTasks() (string, error){
	return ztm.GetAllTasks()
}

func GetTasksByRealm(realmId string) (string, error){
	return ztm.GetTasksByRealm(realmId)
}

func GetTasksByContext(contextId string) (string, error){
	return ztm.GetTasksByContext(contextId)
}

func GetTasksByDate(dueDate string, filterType string) (string, error){
	return ztm.GetTasksByDate(dueDate, filterType)
}

// projects

func AddProject(wp *WorkableProject) error {
	return zpm.AddProject(wp.Project)
}

func EditProject(wp *WorkableProject) error {
	return zpm.EditProject(wp.Project)
}

func RemoveProject(wp *WorkableProject) error {
	return zpm.RemoveProject(wp.Project)
}

func MoveProjectToRealm(wp WorkableProject, realmId string) error {
	return zpm.MoveProjectToRealm(wp.Project, realmId)
}

func GetProjectTasks(wp WorkableProject) ([]WorkableTask, error){
	tasks, err := zpm.GetProjectTasks(wp.Project)
	if err != nil {
		return nil, err
	}

	// Convert []zentasktic.Task to []WorkableTask
	var workableTasks []WorkableTask
	for _, task := range tasks {
		workableTasks = append(workableTasks, WorkableTask{Task: task})
	}

	return workableTasks, nil
}

func SetProjectDueDate(wp WorkableProject, dueDate string) error {
	return zpm.SetProjectDueDate(wp.Project, dueDate)
}

func GetProjectById(projectId string) (WorkableProject, error) {
	project, err := zpm.GetProjectById(projectId)
	if err != nil {
		return WorkableProject{}, err
	}
	return WorkableProject{Project: project}, nil
}

func GetAllProjects() (string, error){
	return zpm.GetAllProjects()
}

func GetProjectsByRealm(realmId string) (string, error){
	return zpm.GetProjectsByRealm(realmId)
}

func GetProjectsByContext(contextId string) (string, error){
	return zpm.GetProjectsByContext(contextId)
}

func GetProjectsByDate(dueDate string, filterType string) (string, error){
	return zpm.GetProjectsByDate(dueDate, filterType)
}

// realms

func AddRealm(wr WorkableRealm) error {
	r := zentasktic.Realm{
		Id:   wr.Id,
		Name: wr.Name,
	}
	return zrm.AddRealm(r)
}

func RemoveRealm(wr WorkableRealm) error {
	r := zentasktic.Realm{
		Id:   wr.Id,
		Name: wr.Name,
	}
	return zrm.RemoveRealm(r)
}

func GetRealmById(realmId string) (WorkableRealm, error) {
	r, err := zrm.GetRealmById(realmId)
	if err != nil {
		return WorkableRealm{}, err
	}
	return WorkableRealm{
		Id:   r.Id,
		Name: r.Name,
	}, nil
}

func GetAllRealms() (string, error) {
	return zrm.GetRealms()
}

// contexts

func AddContext(wc WorkableContext) error {
	c := zentasktic.Context{
		Id:   wc.Id,
		Name: wc.Name,
	}
	return zcm.AddContext(c)
}

func EditContext(wc WorkableContext) error {
	c := zentasktic.Context{
		Id:   wc.Id,
		Name: wc.Name,
	}
	return zcm.EditContext(c)
}

func RemoveContext(wc WorkableContext) error {
	c := zentasktic.Context{
		Id:   wc.Id,
		Name: wc.Name,
	}
	return zcm.RemoveContext(c)
}

func GetContextById(contextId string) (WorkableContext, error) {
	c, err := zcm.GetContextById(contextId)
	if err != nil {
		return WorkableContext{}, err
	}
	return WorkableContext{
		Id:   c.Id,
		Name: c.Name,
	}, nil
}

func GetAllContexts() (string, error) {
	return zcm.GetAllContexts()
}

// collections

func AddCollection(wc WorkableCollection) error {
	c := zentasktic.Collection{
		Id:       wc.Id,
		RealmId:  wc.RealmId,
		Name:     wc.Name,
		Tasks:    toZentaskticTasks(wc.Tasks),
		Projects: toZentaskticProjects(wc.Projects),
	}
	return zcl.AddCollection(c)
}

func EditCollection(wc WorkableCollection) error {
	c := zentasktic.Collection{
		Id:       wc.Id,
		RealmId:  wc.RealmId,
		Name:     wc.Name,
		Tasks:    toZentaskticTasks(wc.Tasks),
		Projects: toZentaskticProjects(wc.Projects),
	}
	return zcl.EditCollection(c)
}

func RemoveCollection(wc WorkableCollection) error {
	c := zentasktic.Collection{
		Id:       wc.Id,
		RealmId:  wc.RealmId,
		Name:     wc.Name,
		Tasks:    toZentaskticTasks(wc.Tasks),
		Projects: toZentaskticProjects(wc.Projects),
	}
	return zcl.RemoveCollection(c)
}

func GetCollectionById(collectionId string) (WorkableCollection, error) {
	c, err := zcl.GetCollectionById(collectionId)
	if err != nil {
		return WorkableCollection{}, err
	}
	return WorkableCollection{
		Id:       c.Id,
		RealmId:  c.RealmId,
		Name:     c.Name,
		Tasks:    toWorkableTasks(c.Tasks),
		Projects: toWorkableProjects(c.Projects),
	}, nil
}

func GetCollectionTasks(wc WorkableCollection) ([]WorkableTask, error) {
	c := zentasktic.Collection{
		Id: wc.Id,
	}
	tasks, err := zcl.GetCollectionTasks(c)
	if err != nil {
		return nil, err
	}
	return toWorkableTasks(tasks), nil
}

func GetCollectionProjects(wc WorkableCollection) ([]WorkableProject, error) {
	c := zentasktic.Collection{
		Id: wc.Id,
	}
	projects, err := zcl.GetCollectionProjects(c)
	if err != nil {
		return nil, err
	}
	return toWorkableProjects(projects), nil
}

func GetAllCollections() (string, error) {
	return zcl.GetAllCollections()
}

// Helper functions to convert between Workable and zentasktic types
func toZentaskticTasks(tasks []WorkableTask) []zentasktic.Task {
	ztasks := make([]zentasktic.Task, len(tasks))
	for i, t := range tasks {
		ztasks[i] = t.Task
	}
	return ztasks
}

func toWorkableTasks(tasks []zentasktic.Task) []WorkableTask {
	wtasks := make([]WorkableTask, len(tasks))
	for i, t := range tasks {
		wtasks[i] = WorkableTask{Task: t}
	}
	return wtasks
}

func toZentaskticProjects(projects []WorkableProject) []zentasktic.Project {
	zprojects := make([]zentasktic.Project, len(projects))
	for i, p := range projects {
		zprojects[i] = p.Project
	}
	return zprojects
}

func toWorkableProjects(projects []zentasktic.Project) []WorkableProject {
	wprojects := make([]WorkableProject, len(projects))
	for i, p := range projects {
		wprojects[i] = WorkableProject{Project: p}
	}
	return wprojects
}

// object Paths

func AddPath(wop WorkableObjectPath) error {
	o := zentasktic.ObjectPath{
		ObjectType: wop.ObjectType,
		Id:         wop.Id,
		RealmId:    wop.RealmId,
	}
	return zom.AddPath(o)
}


func GetObjectJourney(objectType string, objectId string) (string, error) {
	return zom.GetObjectJourney(objectType, objectId)
}