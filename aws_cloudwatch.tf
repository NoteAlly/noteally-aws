# 
# VARIABLES
# 

variable "api_gateway_name" {
  type    = string
  default = "api_gateway"
}

variable "api_gateway_stage" {
  type    = string
  default = "dev"
}


# 
# CloudWatch Log Group
# 

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "noteally_log_group"
  skip_destroy      = false
  retention_in_days = 30

  tags = {
    Environment = "production"
    Application = "Noteally"
  }
}

# 
# AWS CLOUDWATCH DASHBOARD
# 

resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = "noteally-dashboard"

  dashboard_body = jsonencode(
    {
      "widgets" : [
        {
          "height" : 3,
          "width" : 12,
          "y" : 0,
          "x" : 0,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/AmplifyHosting", "Requests", "App", "${aws_amplify_app.web_app.id}", { "region" : "eu-north-1" }],
              [".", "Latency", ".", ".", { "stat" : "Average", "region" : "eu-north-1" }],
              [".", "BytesDownloaded", ".", ".", { "label" : "Bytes Downloaded", "region" : "eu-north-1" }],
              [".", "BytesUploaded", ".", ".", { "label" : "Bytes Uploaded", "region" : "eu-north-1" }]
            ],
            "view" : "singleValue",
            "region" : "eu-north-1",
            "stat" : "Sum",
            "period" : 300,
            "setPeriodToTimeRange" : true,
            "stacked" : false,
            "title" : "Amplify (Web App) - Last 5 minutes"
          }
        },
        {
          "height" : 8,
          "width" : 12,
          "y" : 3,
          "x" : 0,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/AmplifyHosting", "Requests", "App", "${aws_amplify_app.web_app.id}", { "region" : "eu-north-1" }],
              [".", "Latency", ".", ".", { "region" : "eu-north-1", "stat" : "Average" }],
              [".", "BytesUploaded", ".", ".", { "region" : "eu-north-1", "label" : "Bytes Uploaded" }],
              [".", "BytesDownloaded", ".", ".", { "region" : "eu-north-1", "label" : "Bytes Downloaded" }],
              [".", "4xxErrors", ".", ".", { "region" : "eu-north-1", "label" : "4xx Errors" }],
              [".", "5xxErrors", ".", ".", { "region" : "eu-north-1", "label" : "5xx Errors" }]
            ],
            "view" : "timeSeries",
            "stacked" : false,
            "region" : "eu-north-1",
            "title" : "Amplify (Web App) - History",
            "period" : 300,
            "stat" : "Sum"
          }
        },
        {
            "height" : 3,
            "width" : 12,
            "y" : 11,
            "x" : 0,
            "type": "metric",
            "properties": {
                "view": "singleValue",
                "metrics": [
                    [ "ECS/ContainerInsights", "CpuUtilized", "ServiceName", "noteally_service", "ClusterName", "noteally_cluster" ],
                    [ ".", "NetworkTxBytes", ".", ".", ".", "." ],
                    [ ".", "MemoryUtilized", ".", ".", ".", "." ],
                    [ ".", "NetworkRxBytes", ".", ".", ".", "." ]
                ],
                "region": "eu-north-1"
            }
        },
        {
            "height" : 8,
            "width" : 12,
            "y" : 14,
            "x" : 0,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "ECS/ContainerInsights", "NetworkRxBytes", "ServiceName", "noteally_service", "ClusterName", "noteally_cluster" ],
                    [ ".", "CpuUtilized", ".", ".", ".", "." ],
                    [ ".", "NetworkTxBytes", ".", ".", ".", "." ],
                    [ ".", "MemoryUtilized", ".", ".", ".", "." ],
                    [ ".", "EphemeralStorageUtilized", ".", ".", ".", "." ]
                ],
                "region": "eu-north-1"
            }
        },
        {
            "height": 3,
            "width": 12,
            "y": 0,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/ApiGateway", "Count", "ApiName", "${var.api_gateway_name}", "Stage", "${var.api_gateway_stage}", { "region": "eu-north-1", "stat": "Sum" } ],
                    [ ".", "Latency", ".", ".", ".", ".", { "region": "eu-north-1" } ],
                    [ ".", "IntegrationLatency", ".", ".", ".", ".", { "label": "Integration Latency", "region": "eu-north-1" } ]
                ],
                "period": 300,
                "region": "eu-north-1",
                "stat": "Average",
                "title": "API Gateway - Last 5 minutes",
                "view": "singleValue"
            }
        },
        {
            "height": 8,
            "width": 12,
            "y": 3,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/ApiGateway", "Count", "ApiName", "${var.api_gateway_name}", "Stage", "${var.api_gateway_stage}" ],
                    [ ".", "Latency", ".", ".", ".", ".", { "stat": "Average" } ],
                    [ ".", "IntegrationLatency", ".", ".", ".", ".", { "label": "Integration Latency", "stat": "Average" } ],
                    [ ".", "4XXError", ".", ".", ".", ".", { "label": "4XX Error" } ],
                    [ ".", "5XXError", ".", ".", ".", ".", { "label": "5XX Error" } ]
                ],
                "period": 300,
                "region": "eu-north-1",
                "stacked": false,
                "stat": "Sum",
                "title": "API Gateway - History",
                "view": "timeSeries"
            }
        },
        {
          "height" : 3,
          "width" : 12,
          "y" : 11,
          "x" : 12,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", "${local.envs["DB_IDENTIFIER"]}", { "label" : "Free Storage Space" }],
              [".", "ReadLatency", ".", ".", { "label" : "Read Latency" }],
              [".", "CPUUtilization", ".", ".", { "label" : "CPU Usage" }],
              [".", "FreeableMemory", ".", ".", { "label" : "Freeable Memory" }]
            ],
            "view" : "singleValue",
            "region" : "eu-north-1",
            "stat" : "Average",
            "period" : 60,
            "title" : "RDS PostgreSQL - Last 5 minutes"
          }
        },
        {
          "height" : 8,
          "width" : 12,
          "y" : 14,
          "x" : 12,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/RDS", "ReadLatency", "DBInstanceIdentifier", "${local.envs["DB_IDENTIFIER"]}", { "label" : "Read Latency (s)" }],
              [".", "WriteLatency", ".", ".", { "label" : "Write Latency (s)" }],
              [".", "ReadThroughput", ".", ".", { "label" : "Read Throughput (bytes/s)" }],
              [".", "WriteThroughput", ".", ".", { "label" : "Write Throughput (bytes/s)" }],
              [".", "FreeStorageSpace", ".", ".", { "label" : "Free Storage Space (bytes)" }],
              [".", "FreeableMemory", ".", ".", { "label" : "Freeable Memory (bytes)" }],
              [".", "SwapUsage", ".", ".", { "label" : "Swap Usage (bytes)" }],
              [".", "CPUUtilization", ".", ".", { "label" : "CPU Usage (%)" }]
            ],
            "view" : "timeSeries",
            "stacked" : false,
            "region" : "eu-north-1",
            "stat" : "Average",
            "period" : 300,
            "title" : "RDS PostgreSQL - History"
          }
        }
      ]
    }
  )
}
