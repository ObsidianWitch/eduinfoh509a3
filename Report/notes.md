% A3 - XQuery

# Links

* http://www.xpathtester.com/xquery
* http://xqilla.sourceforge.net/HomePage

# General

* the xqilla cmmand line utility was used to run our queries
~~~
xqilla authors_coauthors.xq > Output/authors_coauthors_int.xml
~~~

* the xpathtester website (see above) can also be used to run quick tests easily

* the output is not indented correcly using ```declare boundary-space preserve;```.
In order to have correct indentation we can set ```declare boundary-space strip;```
(which is the default even if it is not declared) and use an external tool such
as xmllint.
~~~
xqilla authors_coauthors.xq > Output/authors_coauthors_int.xml
xmllint --format authors_coauthors_int.xml > authors_coauthors.xml
~~~
