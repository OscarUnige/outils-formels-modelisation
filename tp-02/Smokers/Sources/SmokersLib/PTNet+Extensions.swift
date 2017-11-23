import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }
}

public extension PTNet {

    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
        // Write here the implementation of the marking graph generation.
        
        //On créé une variable de type MarkingGraph qui contient le marquage initial.
        let node = MarkingGraph(marking: marking)
        //On créé deux listes de MarkingGraphs, une vide et l'autre contenant l'element initial.
        var seen = [MarkingGraph]()
        var toVisit = [node]
        
        //Tant que la liste des noeuds à visiter n'est pas vide on la parcourt.
        while let current = toVisit.popLast() {
            //Pour toutes les transitions:
            for uneTransition in self.transitions {
                //Si la transition est tirable:
                let marquage = uneTransition.fire(from: current.marking)
                if marquage != nil {
                    let nouveauMarquage = MarkingGraph(marking: marquage!)
                    //Si ce nouveau marquage tirable n'as pas encore été vu on l'ajoute à la liste seen puis on recommencera la boucle avec nouveauMarquage comme marquage initial.
                    if !seen.contains(where: {$0.marking == current.marking}) {
                        seen.append(current)
                        toVisit.append(nouveauMarquage)
                    }
                    //Si les bonnes conditions sont satisfaites on définit les successeurs.
                    if toVisit.contains(where: {$0.marking == marquage!}) {
                        current.successors[uneTransition] = toVisit.first(where: {$0.marking == marquage!})
                    }
                    else if seen.contains(where: {$0.marking == marquage!}) {
                        current.successors[uneTransition] = seen.first(where: {$0.marking == marquage!})
                    }
                    current.successors[uneTransition] = nouveauMarquage
                }
            }
        }
        return node
    }
}
