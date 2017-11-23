import PetriKit
import PhilosophersLib

 do {
    enum C: CustomStringConvertible {
        case b, v, o
        
        var description: String {
            switch self {
            case .b: return "b"
            case .v: return "v"
            case .o: return "o"
            }
        }
    }
    
    func g(binding: PredicateTransition<C>.Binding) -> C {
        switch binding["x"]! {
        case .b: return .v
        case .v: return .b
        case .o: return .o
        }
    }
    
    let t1 = PredicateTransition<C>(
        preconditions: [
            PredicateArc(place: "p1", label: [.variable("x")]),
        ],
        postconditions: [
            PredicateArc(place: "p2", label: [.function(g)]),
        ])
    
    let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []]
    guard let m1 = t1.fire(from: m0, with: ["x": .b]) else {
        fatalError("Failed to fire.")
    }
    print(m1)
    guard let m2 = t1.fire(from: m1, with: ["x": .v]) else {
        fatalError("Failed to fire.")
    }
    print(m2)
 }

do {
    let philosophers2 = lockablePhilosophers(n: 5)
    let philosophers = lockFreePhilosophers(n: 5)
    
    print("1. Combien y a-t-il de marquages possibles dans le modele des philosophes non bloquable a 5 philosophes?")
    let philosophersMarkingGraph = philosophers.markingGraph(from: philosophers.initialMarking!)
    print(philosophersMarkingGraph!.count,"\n")
    
    print("2. Combien y a-t-il de marquages possibles dans le modele des philosophes bloquable a 5 philosophes?")
    let philosophers2MarkingGraph = philosophers2.markingGraph(from: philosophers2.initialMarking!)
    print(philosophers2MarkingGraph!.count,"\n")
    
    print("3. Donnez un exemple d’etat ou le reseau est bloque dans le modele des philosophes bloquable a 5 philosophes?")
    for aMarkingGraph in philosophers2MarkingGraph! {
        var nbrSuccessors = 0
        for (_, successorsByBinding) in aMarkingGraph.successors {
            if !(successorsByBinding.isEmpty) {
                nbrSuccessors += 1
            }
        }
        if (nbrSuccessors == 0) {  //S'il n'y a pas de successeur alors c'est un etat où le reseau est bloqué
            print(aMarkingGraph.marking,"\n")
            break
        }
    }
}
