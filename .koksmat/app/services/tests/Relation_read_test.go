/*
File have been automatically created. To prevent the file from getting overwritten
set the Front Matter property ´keep´ to ´true´ syntax for the code snippet
---
keep: false
---
*/
//generator:  noma4.1
package tests

import (
	"testing"

	"github.com/nexiintra/nexiintra-operations/services/endpoints/relation"

	"github.com/stretchr/testify/assert"
)

func TestRelationread(t *testing.T) {

	result, err := relation.RelationRead(".")
	if err != nil {
		t.Errorf("Error %s", err)
	}
	assert.NotNil(t, result)

}
