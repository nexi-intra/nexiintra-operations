// -------------------------------------------------------------------
// Generated by 365admin-publish
// -------------------------------------------------------------------
/*
---
title: Parse Users
---
*/
package cmds

import (
	"context"
	"os"
	"path"

	"github.com/nexiintra/nexiintra-operations/execution"
	"github.com/nexiintra/nexiintra-operations/utils"
)

func AnalyseParseUsersPost(ctx context.Context, body []byte, args []string) (*string, error) {
	inputErr := os.WriteFile(path.Join(utils.WorkDir("magic-people"), "userssample.json"), body, 0644)
	if inputErr != nil {
		return nil, inputErr
	}

	result, pwsherr := execution.ExecutePowerShell("john", "*", "magic-people", "30-analyse", "10-parse-users.ps1", "")
	if pwsherr != nil {
		return nil, pwsherr
	}
	utils.PrintSkip2FirstAnd2LastLines(string(result))
	return nil, nil

}
