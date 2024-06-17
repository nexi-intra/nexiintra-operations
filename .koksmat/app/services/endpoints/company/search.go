/*
File have been automatically created. To prevent the file from getting overwritten
set the Front Matter property ´´keep´´ to ´´true´´ syntax for the code snippet
---
keep: false
---
*/
//generator:  noma3.search.v2
package company

import (
	"log"

	"github.com/nexiintra/nexiintra-operations/applogic"
	"github.com/nexiintra/nexiintra-operations/database"
	"github.com/nexiintra/nexiintra-operations/services/models/companymodel"
	. "github.com/nexiintra/nexiintra-operations/utils"
)

func CompanySearch(query string) (*Page[companymodel.Company], error) {
	log.Println("Calling Companysearch")

	return applogic.Search[database.Company, companymodel.Company]("searchindex", query, applogic.MapCompanyOutgoing)

}
