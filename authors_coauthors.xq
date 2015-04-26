xquery version "1.0";
declare boundary-space strip;

declare namespace ufn = "urn:user.fn";

declare function ufn:coauthors($author, $author_publications) {
    let $coauthors := fn:distinct-values($author_publications/author[. != $author])
    let $nb_coauthors := fn:count($coauthors)
    
    return
        <coauthors number="{$nb_coauthors}">
        {
            for $coauth in $coauthors
                let $common_publications := $author_publications[author = $coauth]
                let $nb_common_publications := fn:count($common_publications)
                
                return
                    <coauthor>
                        <name>{$coauth}</name>
                        <nb_joint_pubs>{$nb_common_publications}</nb_joint_pubs>
                    </coauthor>
        }
        </coauthors>
};

<authors_coauthors>
{
    let $dblp := fn:doc("Data/dblp-excerpt.xml")
    
    let $publications := $dblp/dblp/*
    let $authors := fn:distinct-values($publications/author)
    
    for $auth in $authors
        let $author_publications := $publications[author = $auth]

        return
            <author>
                <name>{$auth}</name>
                {ufn:coauthors($auth, $author_publications)}
            </author>
}
</authors_coauthors>
