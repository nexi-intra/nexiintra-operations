/*
File have been automatically created. To prevent the file from getting overwritten
set the Front Matter property ´´keep´´ to ´´true´´ syntax for the code snippet
---
keep: false
---
*/
//generator:  noma3.create.v2
package relation

import (
	"log"

	"github.com/nexiintra/nexiintra-operations/applogic"
	"github.com/nexiintra/nexiintra-operations/database"
	"github.com/nexiintra/nexiintra-operations/services/models/relationmodel"
)

func RelationCreate(item relationmodel.Relation) (*relationmodel.Relation, error) {
	log.Println("Calling Relationcreate")

	return applogic.Create[database.Relation, relationmodel.Relation](item, applogic.MapRelationIncoming, applogic.MapRelationOutgoing)

}
