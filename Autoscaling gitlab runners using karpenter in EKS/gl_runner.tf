data "aws_secretsmanager_secret" "gitlab-runner-token" {
  name = "/gitlab/k8s/runner/token"
}
data "aws_secretsmanager_secret_version" "gitlab-runner-token" {
  secret_id = data.aws_secretsmanager_secret.gitlab-runner-token.id
}

resource "helm_release" "gitlab" {
  name = "gitlab"
  namespace = "gitlab"
  create_namespace = true
  chart = "gitlab-runner"
  repository = "https://charts.gitlab.io"
  set = [ {
    name = "runnerToken"
    value = jsondecode(data.aws_secretsmanager_secret_version.gitlab-runner-token.secret_string)["GL_TOKEN"]
  },
  {
    name = "gitlabUrl"
    value = "https://gitlab.com"
  },
  {
    name = "rbac.create"
    value = true
  },
  {
    name = "runners.config"
    value = <<-EOT
concurrent = 100
[[runners]]
    executor = "kubernetes"
    [runners.kubernetes]
    namespace = "gitlab"
    image = "alpine:latest"
    
    # Default
    cpu_request = "100m"
    memory_request = "100Mi"
    cpu_limit = "1000m"
    memory_limit = "1000Mi"

    #overwrite variables
    cpu_request_overwrite_max_allowed = "60"
    memory_request_overwrite_max_allowed = "60Gi"
    cpu_limit_overwrite_max_allowed = "80"
    memory_limit_overwrite_max_allowed = "80Gi"
    EOT
  }
]
}