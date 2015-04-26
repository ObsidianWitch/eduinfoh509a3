xquery version "1.0";
declare boundary-space strip;

declare namespace ufn = "urn:user.fn";

declare function ufn:inproceedings($key, $dblp) {
    let $inproceedings := $dblp/dblp/*[fn:name() = "inproceedings" and crossref = $key]
    
    for $inproc in $inproceedings
        return
            <title>{$inproc/title/text()}</title>
};

<proceedings>
{
    let $dblp := fn:doc("Data/dblp-excerpt.xml")
    let $proceedings := $dblp/dblp/*[fn:name() = "proceedings"]
    
    for $proc in $proceedings
        let $proc_title := <proc_title>{$proc/title/text()}</proc_title>
        let $inproc_titles := ufn:inproceedings($proc/@key, $dblp)
    
        return (
            $proc_title,
            $inproc_titles
        )
}
</proceedings>
