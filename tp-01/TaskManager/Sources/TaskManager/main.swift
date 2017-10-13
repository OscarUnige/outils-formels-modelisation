import TaskManagerLib

let taskManager = createTaskManager()

// Show here an example of sequence that leads to the described problem.
// For instance:
//     let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
//     let m2 = spawn.fire(from: m1!)
//     ...

/* Le problène est que si on fait un create, on obtient un jeton dans taskPool qui ne s'en va pas lors de l'exec, puisque taskPool est une postcondition de exec, alors ce jeton peut être utilisé pour lancer un deuxième exec alors qu'en realité il n'y a qu'une tache à accomplir, donc ce deuxième exec est voué à l'echec. */

//On redéfinit les places et transitions.
let taskPool    = taskManager.places.first { $0.name == "taskPool" }!
let processPool = taskManager.places.first { $0.name == "processPool" }!
let inProgress  = taskManager.places.first { $0.name == "inProgress" }!
let create      = taskManager.transitions.first { $0.name == "create" }!
let spawn       = taskManager.transitions.first { $0.name == "spawn" }!
let exec        = taskManager.transitions.first { $0.name == "exec" }!
let success     = taskManager.transitions.first { $0.name == "success" }!
let fail        = taskManager.transitions.first { $0.name == "fail" }!

//La sequence qui pose problème:
let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
print("1 create:    ",m1!)
let m2 = spawn.fire(from: m1!)
print("1 spawn:     ",m2!)
let m3 = spawn.fire(from: m2!)
print("Second spawn:",m3!)
let m4 = exec.fire(from: m3!)
print("1 exec:      ",m4!)
let m5 = exec.fire(from: m4!)
print("Second exec: ",m5!)
let m6 = success.fire(from: m5!)
print("1 success:   ",m6!)
//La première tache finit bien avec un success
print("Is success fireable? ",success.isFireable(from: m6!),"\n")
//Mais le deuxième exec ne peut pas finir avec success. Il y a un problème.

let correctTaskManager = createCorrectTaskManager()

// Show here that you corrected the problem.
// For instance:
//     let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
//     let m2 = spawn.fire(from: m1!)
//     ...

/* On definit les nouvelles places et transitions: on rajoute une place availableExecs, cette place est une post condition de create donc une fois qu'on rajoute une tache on peut l'executer, et availableExecs est une précondition de exec donc on ne peut pas executer une tache sans avoir de tache à executer. */
let correctTaskPool    = correctTaskManager.places.first { $0.name == "taskPool" }!
let correctProcessPool = correctTaskManager.places.first { $0.name == "processPool" }!
let correctInProgress  = correctTaskManager.places.first { $0.name == "inProgress" }!
let availableExecs     = correctTaskManager.places.first { $0.name == "availableExecs" }!
let correctCreate      = correctTaskManager.transitions.first { $0.name == "create" }!
let correctSpawn       = correctTaskManager.transitions.first { $0.name == "spawn" }!
let correctExec        = correctTaskManager.transitions.first { $0.name == "exec" }!
let correctSuccess     = correctTaskManager.transitions.first { $0.name == "success" }!
let correctFail        = correctTaskManager.transitions.first { $0.name == "fail" }!

//On lance la même séquence avec les nouvelles transitions:
let m21 = correctCreate.fire(from: [correctTaskPool: 0, correctProcessPool: 0, correctInProgress: 0, availableExecs: 0])
print("1 create:    ",m21!)
let m22 = correctSpawn.fire(from: m21!)
print("1 spawn:     ",m22!)
let m23 = correctSpawn.fire(from: m22!)
print("Second spawn:",m23!)
let m24 = correctExec.fire(from: m23!)
print("1 exec:      ",m24!)
print("Can we now get a second task in progress? ", correctExec.isFireable(from: m24!))
/*Puisqu'on n'a fait que 1 create il n'y a qu'une tache à accomplir alors le programme ne nous laisse pas lancer un deuxième exec qui echouerait*/
print("Will the first task still succeed? ", correctSuccess.isFireable(from: m24!))

//La suite ne peut pas être executée.
/*let m25 = correctExec.fire(from: m24!)
 print("m25=",m25!)
 let m26 = correctSuccess.fire(from: m25!)
 print("m26=",m26!)*/

