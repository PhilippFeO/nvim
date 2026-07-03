-- Works but shows this message:
--		LSP[djlsp] Failed to collect project-specific Django data. Falling back to default Django completions.
return {
	init_options = {
		django_settings_module = "kursverwaltung.settings_dev",
		env_directories = { vim.fn.expand '~/programmieren/kursverwaltung/.venv' },
		-- docker_compose_file = "docker-compose.yml",
		-- docker_compose_service = "django"
	}
}
