xquery version "1.0";

module namespace ufng = "urn:user.fn.graph";

declare function ufng:initGraph($publications) {
    let $authors := fn:distinct-values($publications/author)
    let $nodes := ufng:initNodes($publications, $authors)
    let $edges := ufng:initEdges($publications, $authors, $nodes)
    
    return element graph {
        element nodes { $nodes },
        element edges { $edges }
    }
};

declare function ufng:initNodes($publications, $authors) {
    for $auth at $i in $authors
        
        return element node {
            attribute id { $i },
            attribute name { $auth }
        }
};

declare function ufng:initEdges($publications, $authors, $nodes) {
    for $auth at $i in $authors
        let $author_publications := $publications[author = $auth]
        let $coauthors := fn:distinct-values($author_publications/author[. != $auth])
        let $visited := ()
        
        for $coauth in $coauthors
            let $coauth_id := data($nodes[@name = $coauth]/@id)
            
            (: avoid duplicates (undirected graph) :)
            return if ($i < $coauth_id) then
                element edge {
                    attribute from { $i },
                    attribute to { $coauth_id }
                }
            else ()
};
