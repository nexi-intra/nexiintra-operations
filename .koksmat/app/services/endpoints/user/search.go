/*
File have been automatically created. To prevent the file from getting overwritten
set the Front Matter property ´´keep´´ to ´´true´´ syntax for the code snippet
---
keep: false
---
*/
//generator:  noma3.search.v2
package user

import (
	"log"

	"github.com/nexiintra/nexiintra-operations/applogic"
	"github.com/nexiintra/nexiintra-operations/database"
	"github.com/nexiintra/nexiintra-operations/services/models/usermodel"
	. "github.com/nexiintra/nexiintra-operations/utils"
)

func UserSearch(query string) (*Page[usermodel.User], error) {
	log.Println("Calling Usersearch")

	return applogic.Search[database.User, usermodel.User]("searchindex", query, applogic.MapUserOutgoing)

}
