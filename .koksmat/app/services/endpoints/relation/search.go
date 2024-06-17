/*
File have been automatically created. To prevent the file from getting overwritten
set the Front Matter property ´´keep´´ to ´´true´´ syntax for the code snippet
---
keep: false
---
*/
//generator:  noma3.search.v2
package relation

import (
	"log"

	"github.com/nexiintra/nexiintra-operations/applogic"
	"github.com/nexiintra/nexiintra-operations/database"
	"github.com/nexiintra/nexiintra-operations/services/models/relationmodel"
	. "github.com/nexiintra/nexiintra-operations/utils"
)

func RelationSearch(query string) (*Page[relationmodel.Relation], error) {
	log.Println("Calling Relationsearch")

	return applogic.Search[database.Relation, relationmodel.Relation]("searchindex", query, applogic.MapRelationOutgoing)

}
