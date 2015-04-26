xquery version "1.0";
declare boundary-space strip;

declare namespace ufn = "urn:user.fn";
import module namespace ufng = "urn:user.fn.graph" at "graph.xq";

declare function ufn:rec($author, $author_publications, $level) {
    let $coauthors := fn:distinct-values($author_publications/author[. != $author])
    
    for $coauth in $coauthors
        let $distance_element := <distance author1="{$author}" author2="{$coauth}" distance="{$level}"/>
    
        return if (not(empty($coauthors))) then (
            $distance_element
        ) else ()
};

(:
 : Recursivly computes distances from this $node to all neighbouring nodes
 : using the given $graph. The $visited sequence is used in order to avoid
 : being stuck in a cycle.
 :)
declare function ufn:distances($graph, $node, $visited, $level) {
    let $coauthors_edges := $graph/edges/edge[@from = $node/@id]
    let $coauthors := $graph/nodes/node[@id = $coauthors_edges/@to]
    
    for $coauthor in $coauthors
        return element distance {
            attribute author1 { data($node/@name) },
            attribute author2 { data($coauthor/@name) },
            attribute distance { $level }
        }
};

declare function ufn:distances($graph) {
    let $distances := (
        for $node in $graph/nodes/node
            return ufn:distances($graph, $node, (), 1)
    )
    
    return element distances { $distances }
};

let $dblp := fn:doc("Data/dblp-excerpt.xml")
let $publications := $dblp/dblp/*
let $graph := ufng:initGraph($publications)

return ufn:distances($graph)
