// -------------------------------------------------------------------
// Generated by 365admin-publish/api/20 makeschema.ps1
// -------------------------------------------------------------------
/*
---
title: Parse Groups
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

func AnalyseParseGroupsPost() usecase.Interactor {
	type Request struct {
		Body schemas.Infocastgroups `json:"body" binding:"required"`
	}
	u := usecase.NewInteractor(func(ctx context.Context, input Request, output *string) error {
		body, inputErr := json.Marshal(input.Body)
		if inputErr != nil {
			return inputErr
		}

		inputErr = os.WriteFile(path.Join(utils.WorkDir("magic-people"), "InfocastGroups.json"), body, 0644)
		if inputErr != nil {
			return inputErr
		}

		_, err := execution.ExecutePowerShell("john", "*", "magic-people", "30-analyse", "10-parse-groups.ps1", "")
		if err != nil {
			return err
		}

		return err

	})
	u.SetTitle("Parse Groups")
	// u.SetExpectedErrors(status.InvalidArgument)
	u.SetTags("30-analyse")
	return u
}
