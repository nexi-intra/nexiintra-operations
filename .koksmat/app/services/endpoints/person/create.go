/*
File have been automatically created. To prevent the file from getting overwritten
set the Front Matter property ´´keep´´ to ´´true´´ syntax for the code snippet
---
keep: false
---
*/
//generator:  noma3.create.v2
package person

import (
	"log"

	"github.com/nexiintra/nexiintra-operations/applogic"
	"github.com/nexiintra/nexiintra-operations/database"
	"github.com/nexiintra/nexiintra-operations/services/models/personmodel"
)

func PersonCreate(item personmodel.Person) (*personmodel.Person, error) {
	log.Println("Calling Personcreate")

	return applogic.Create[database.Person, personmodel.Person](item, applogic.MapPersonIncoming, applogic.MapPersonOutgoing)

}
