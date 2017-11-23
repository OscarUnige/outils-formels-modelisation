import PetriKit
import SmokersLib

// Instantiate the model.
let model = createModel()
// Retrieve places model.
guard let r  = model.places.first(where: { $0.name == "r" }),
    let p  = model.places.first(where: { $0.name == "p" }),
    let t  = model.places.first(where: { $0.name == "t" }),
    let m  = model.places.first(where: { $0.name == "m" }),
    let w1 = model.places.first(where: { $0.name == "w1" }),
    let s1 = model.places.first(where: { $0.name == "s1" }),
    let w2 = model.places.first(where: { $0.name == "w2" }),
    let s2 = model.places.first(where: { $0.name == "s2" }),
    let w3 = model.places.first(where: { $0.name == "w3" }),
    let s3 = model.places.first(where: { $0.name == "s3" }),
    let tpt = model.transitions.first(where: { $0.name == "tpt" }),
    let tpm = model.transitions.first(where: { $0.name == "tpm" }),
    let ttm = model.transitions.first(where: { $0.name == "ttm" }),
    let ts1 = model.transitions.first(where: { $0.name == "ts1" }),
    let ts2 = model.transitions.first(where: { $0.name == "ts2" }),
    let ts3 = model.transitions.first(where: { $0.name == "ts3" }),
    let tw1 = model.transitions.first(where: { $0.name == "tw1" }),
    let tw2 = model.transitions.first(where: { $0.name == "tw2" }),
    let tw3 = model.transitions.first(where: { $0.name == "tw3" })
    else {
        fatalError("invalid model")
}

// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]
//On déclare deux booléens pour les questions de l'ex 4 (ces booléens sont true pour deux ou plus fumeurs ou ingredients mais il semblait peu pratique d'écrire "auMoins" dans leur nom).
var deuxFumeurs = false
var deuxIngredients = false

//L'algorithme vue en classe pour parcourir les noeuds et les compter ainsi que les jetons aux differentes places.
func countNodes(markingGraph : MarkingGraph) -> Int {
    var toVisit = [markingGraph]
    var seen = [markingGraph]
    
    while let current = toVisit.popLast(){
        for (_, successor) in current.successors {
            if !seen.contains(where: { $0 === successor}){
                seen.append(successor)
                toVisit.append(successor)
                //Pour chaque place:
                for (currentPlace, nbJetons) in current.marking{
                    //S'il y a des jetons dans au moins 2 places correspondant à un fumeur en même temps:
                    if ((currentPlace == s1 && currentPlace == s2) || (currentPlace == s1 && currentPlace == s3) || (currentPlace == s2 && currentPlace == s3)) {
                        deuxFumeurs = true
                    }
                    //S'il y a 2 ou plus jetons dans une ou plusieurs des places correspondant aux ingredients:
                    if nbJetons>1 && (currentPlace==p || currentPlace==t || currentPlace==m) {
                        //Alors il est possible d'avoir deux fois le même ingredient sur la table.
                        deuxIngredients = true
                    }
                }
            }
        }
    }
    //On retourne le nombre de marquages différents vus.
    return seen.count
}

// Create the marking graph (if possible).
if let markingGraph = model.markingGraph(from: initialMarking) {
    print("\nExercice 4:\n")
    print("1. Combien d'états différents votre réseau peut-il avoir? ",countNodes(markingGraph: markingGraph), "\n")
    print("2. Est-il possible que deux fumeurs fument en même temps? ", deuxFumeurs, "\n")
    print("3. Est-il possible d'avoir deux fois le même ingredient sur la table? ", deuxIngredients, "\n")
}
