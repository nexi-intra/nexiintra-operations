/*
File have been automatically created. To prevent the file from getting overwritten
set the Front Matter property ´´keep´´ to ´´true´´ syntax for the code snippet
---
keep: false
---
*/
//generator:  noma3.search.v2
package group

import (
	"log"

	"github.com/nexiintra/nexiintra-operations/applogic"
	"github.com/nexiintra/nexiintra-operations/database"
	"github.com/nexiintra/nexiintra-operations/services/models/groupmodel"
	. "github.com/nexiintra/nexiintra-operations/utils"
)

func GroupSearch(query string) (*Page[groupmodel.Group], error) {
	log.Println("Calling Groupsearch")

	return applogic.Search[database.Group, groupmodel.Group]("searchindex", query, applogic.MapGroupOutgoing)

}
