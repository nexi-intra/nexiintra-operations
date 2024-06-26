// -------------------------------------------------------------------
// Generated by 365admin-publish/api/20 makeschema.ps1
// -------------------------------------------------------------------
/*
---
title: Get Groups
---
*/
package endpoints

import (
	"context"
	"encoding/json"
	"os"
	"path"

	"github.com/swaggest/usecase"

	"github.com/nexiintra/nexiintra-operations/execution"
	"github.com/nexiintra/nexiintra-operations/schemas"
	"github.com/nexiintra/nexiintra-operations/utils"
)

func UsecasesGetGroupsPost() usecase.Interactor {
	type Request struct {
	}
	u := usecase.NewInteractor(func(ctx context.Context, input Request, output *schemas.AllGroups) error {

		_, err := execution.ExecutePowerShell("john", "*", "magic-people", "05-usecases", "10-get-groups.ps1", "")
		if err != nil {
			return err
		}

		resultingFile := path.Join(utils.WorkDir("magic-people"), "all-groups.json")
		data, err := os.ReadFile(resultingFile)
		if err != nil {
			return err
		}
		resultObject := schemas.AllGroups{}
		err = json.Unmarshal(data, &resultObject)
		*output = resultObject
		return err

	})
	u.SetTitle("Get Groups")
	// u.SetExpectedErrors(status.InvalidArgument)
	u.SetTags("Use Cases")
	return u
}
