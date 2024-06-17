/*
   File have been automatically created. To prevent the file from getting overwritten
   set the Front Matter property ´´keep´´ to ´´true´´ syntax for the code snippet
   ---
   keep: false
   ---
*/
//generator:  noma3.delete.v2
package person

import (
	"log"
	"strconv"

	"github.com/nexiintra/nexiintra-operations/applogic"
	"github.com/nexiintra/nexiintra-operations/database"
	"github.com/nexiintra/nexiintra-operations/services/models/personmodel"
)

func PersonDelete(arg0 string) error {
	id, _ := strconv.Atoi(arg0)
	log.Println("Calling Persondelete")

	return applogic.Delete[database.Person, personmodel.Person](id)

}
