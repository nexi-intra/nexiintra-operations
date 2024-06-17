/*
File have been automatically created. To prevent the file from getting overwritten
set the Front Matter property ´´keep´´ to ´´true´´ syntax for the code snippet
---
keep: false
---
*/
//generator:  noma3.search.v2
package system

import (
	"log"

	"github.com/nexiintra/nexiintra-operations/applogic"
	"github.com/nexiintra/nexiintra-operations/database"
	"github.com/nexiintra/nexiintra-operations/services/models/systemmodel"
	. "github.com/nexiintra/nexiintra-operations/utils"
)

func SystemSearch(query string) (*Page[systemmodel.System], error) {
	log.Println("Calling Systemsearch")

	return applogic.Search[database.System, systemmodel.System]("searchindex", query, applogic.MapSystemOutgoing)

}
