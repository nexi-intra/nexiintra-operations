/*
File have been automatically created. To prevent the file from getting overwritten
set the Front Matter property ´´keep´´ to ´´true´´ syntax for the code snippet
---
keep: false
---
*/
//generator:  noma3.create.v2
package company

import (
	"log"

	"github.com/nexiintra/nexiintra-operations/applogic"
	"github.com/nexiintra/nexiintra-operations/database"
	"github.com/nexiintra/nexiintra-operations/services/models/companymodel"
)

func CompanyCreate(item companymodel.Company) (*companymodel.Company, error) {
	log.Println("Calling Companycreate")

	return applogic.Create[database.Company, companymodel.Company](item, applogic.MapCompanyIncoming, applogic.MapCompanyOutgoing)

}
