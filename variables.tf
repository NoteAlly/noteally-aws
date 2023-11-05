locals {
    dot_env_file_path   = ".env"
    dot_env_regex       = "(?m:^\\s*([^#\\s]\\S*)\\s*=\\s*[\"']?(.*[^\"'\\s])[\"']?\\s*$)"
    envs                = { for tuple in regexall(local.dot_env_regex, file(local.dot_env_file_path)) : tuple[0] => sensitive(tuple[1]) }
}