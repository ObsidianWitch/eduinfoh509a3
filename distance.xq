xquery version "1.0";
declare boundary-space strip;

declare namespace ufn = "urn:user.fn";
import module namespace ufng = "urn:user.fn.graph" at "graph.xq";

(:
 : Recursivly computes distances from this $node to all neighbouring nodes
 : using the given $graph. The $visited sequence is used in order to avoid
 : being stuck in a cycle.
 :)
declare function ufn:distances($graph, $start, $node, $visited, $level) {
    let $coauthors_edges := $graph/edges/edge[@from = $node/@id and not(@to = $visited)]
    
    return if (not(empty($coauthors_edges))) then (
        for $edge in $coauthors_edges
            let $next_node := $graph/nodes/node[@id = $edge/@to]
            
            return (
                element distance {
                    attribute author1 { data($start/@name) },
                    attribute author2 { data($next_node/@name) },
                    attribute distance { $level }
                },
                ufn:distances($graph, $start, $next_node, ($visited, data($edge/@to)), $level + 1)
            )
    )
    else ()
};

(:
 : Starts the recursive process to calculate distances between authors.
 :)
declare function ufn:distances($graph) {
    let $distances := (
        for $node in $graph/nodes/node
            return ufn:distances($graph, $node, $node, (data($node/@id)), 1)
    )
    
    return element distances { $distances }
};

let $dblp := fn:doc("Data/dblp-excerpt.xml")
let $publications := $dblp/dblp/*
let $graph := ufng:initGraph($publications)
let $distances := ufn:distances($graph)

return $distances
