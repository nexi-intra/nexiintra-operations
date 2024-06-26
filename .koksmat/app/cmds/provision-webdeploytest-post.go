// -------------------------------------------------------------------
// Generated by 365admin-publish
// -------------------------------------------------------------------
/*
---
title: Web deploy to Test
---
*/
package cmds

import (
	"context"

	"github.com/nexiintra/nexiintra-operations/execution"
	"github.com/nexiintra/nexiintra-operations/utils"
)

func ProvisionWebdeploytestPost(ctx context.Context, args []string) (*string, error) {

	result, pwsherr := execution.ExecutePowerShell("john", "*", "nexiintra-operations", "60-provision", "11-web-test.ps1", "")
	if pwsherr != nil {
		return nil, pwsherr
	}
	utils.PrintSkip2FirstAnd2LastLines(string(result))
	return nil, nil

}
