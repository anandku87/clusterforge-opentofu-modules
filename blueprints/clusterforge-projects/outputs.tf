output "shared_project" {
  description = "Shared services hub project details"
  value = {
    project_id     = module.shared_project.project_id
    project_number = module.shared_project.project_number
    project_name   = module.shared_project.project_name
  }
}

output "dev_project" {
  description = "Development spoke project details"
  value = {
    project_id     = module.dev_project.project_id
    project_number = module.dev_project.project_number
    project_name   = module.dev_project.project_name
  }
}

output "prod_project" {
  description = "Production spoke project details"
  value = {
    project_id     = module.prod_project.project_id
    project_number = module.prod_project.project_number
    project_name   = module.prod_project.project_name
  }
}

output "sandbox_project" {
  description = "Sandbox spoke project details"
  value = {
    project_id     = module.sandbox_project.project_id
    project_number = module.sandbox_project.project_number
    project_name   = module.sandbox_project.project_name
  }
}

output "all_projects" {
  description = "Map of all created projects with their details"
  value = {
    shared = {
      project_id     = module.shared_project.project_id
      project_number = module.shared_project.project_number
    }
    dev = {
      project_id     = module.dev_project.project_id
      project_number = module.dev_project.project_number
    }
    prod = {
      project_id     = module.prod_project.project_id
      project_number = module.prod_project.project_number
    }
    sandbox = {
      project_id     = module.sandbox_project.project_id
      project_number = module.sandbox_project.project_number
    }
  }
}

output "platform_service_account_emails" {
  description = "Email addresses of platform service accounts (if created)"
  value = {
    shared  = module.shared_project.service_account_email
    dev     = module.dev_project.service_account_email
    prod    = module.prod_project.service_account_email
    sandbox = module.sandbox_project.service_account_email
  }
}
