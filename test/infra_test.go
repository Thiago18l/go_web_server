package main

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformAwsInfra(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../aws/",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	publicIp := terraform.Output(t, terraformOptions, "public_ip")

	url := fmt.Sprintf("http://%s:8080/api/v1/", publicIp)
	http_helper.HttpGetWithRetry(t, url, nil, 200, `URL.Path = "/api/v1/"`, 30, 5*time.Second)
}
