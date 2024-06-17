/*
File have been automatically created. To prevent the file from getting overwritten
set the Front Matter property ´´keep´´ to ´´true´´ syntax for the code snippet
---
keep: false
---
*/
//generator:  noma3.read.v2
package relation

import (
	"log"
	"strconv"

	"github.com/nexiintra/nexiintra-operations/applogic"
	"github.com/nexiintra/nexiintra-operations/database"
	"github.com/nexiintra/nexiintra-operations/services/models/relationmodel"
)

func RelationRead(arg0 string) (*relationmodel.Relation, error) {
	id, _ := strconv.Atoi(arg0)
	log.Println("Calling Relationread")

	return applogic.Read[database.Relation, relationmodel.Relation](id, applogic.MapRelationOutgoing)

}
