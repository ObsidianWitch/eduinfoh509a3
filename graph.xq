xquery version "1.0";
declare boundary-space strip;

declare namespace ufn = "urn:user.fn";
declare namespace g = "urn:user.graph";

declare function ufn:initGraph($publications) {
    let $authors := fn:distinct-values($publications/author)
    let $nodes := ufn:initNodes($publications, $authors)
    let $edges := ufn:initEdges($publications, $authors, $nodes)
    
    return element graph {
        element nodes { $nodes },
        element edges { $edges }
    }
};

declare function ufn:initNodes($publications, $authors) {
    for $auth at $i in $authors
        let $author_publications := $publications[author = $auth]
        
        return element node {
            attribute id { $i },
            attribute name { $auth }
        }
};

declare function ufn:initEdges($publications, $authors, $nodes) {
    for $auth at $i in $authors
        let $author_publications := $publications[author = $auth]
        let $coauthors := fn:distinct-values($author_publications/author[. != $auth])
        let $visited := ()
        
        for $coauth in $coauthors
            let $coauth_id := data($nodes[@name = $coauth]/@id)
        
            let $edge_id := fn:concat($i, $coauth_id)
            
            (: avoid duplicates (undirected graph) :)
            return if ($i < $coauth_id) then
                element edge {
                    attribute id { $edge_id },
                    attribute from { $i },
                    attribute to { $coauth_id }
                }
            else ()
};

let $dblp := fn:doc("Data/dblp-excerpt.xml")
let $publications := $dblp/dblp/*
return ufn:initGraph($publications)
