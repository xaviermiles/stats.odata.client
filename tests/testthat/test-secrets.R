test_that("Getting/setting subscription key works", {
  # Before ----
  DEFAULT_SECRETS_NAME <- "golem-secrets.yml"
  default_secrets_path <- system.file(DEFAULT_SECRETS_NAME,
                                      package = "statsnz.odata")
  if (default_secrets_path != "") {
    # Move out of the way, will restore afterwards
    legit_secrets <- readLines(default_secrets_path)
    file.remove(default_secrets_path)
  } else {
    # Create it for use in testing
    default_secrets_path <- system.file(package = "statsnz.odata") %>%
      file.path(., "golem-secrets.yml")
  }

  clear_secrets()

  # After ----
  on.exit({
    if (exists("default_secrets_path") && file.exists(default_secrets_path))
      file.remove(default_secrets_path)
    if (exists("tmp2") && file.exists(tmp2))
      file.remove(tmp2)

    # Restore secrets, if there originally was any in the default location
    if (exists("legit_secrets"))
      writeLines(legit_secrets, con = default_secrets_path)
  })

  # Tests ----
  expect_error(
    get_secret("subscription_key"),
    glue::glue("No {DEFAULT_SECRETS_NAME} file.")
  )

  # Add secrets file to default location and check it reads in
  writeLines(c("default:",
               "  subscription_key: dummy-password"),
             con = default_secrets_path)
  expect_equal(
    get_secret("subscription_key"),
    "dummy-password"
  )

  # again, but specifying file in different location
  tmp2 <- tempfile("golem-secrets-testing.yml",
                   tmpdir = system.file(package = "statsnz.odata"))
  writeLines(c("default:",
               "  subscription_key: dummy-password-two"),
             con = tmp2)
  expect_equal(
    get_secret("subscription_key", file = tmp2),
    "dummy-password-two"
  )

  # Add to memory and check this takes precedence over file (even when a file
  # is specified)
  set_secrets("subscription_key" = "dummy-password-two")
  expect_equal(get_secret("subscription_key"), "dummy-password-two")
  expect_equal(
    get_secret("subscription_key", file = default_secrets_path),
    "dummy-password-two"
  )
  expect_equal(
    get_secret("subscription_key", file = tmp2),
    "dummy-password-two"
  )

  # Remove the secrets file and should still read from memory
  file.remove(default_secrets_path)
  expect_equal(get_secret("subscription_key"), "dummy-password-two")
  file.remove(tmp2)
  expect_equal(get_secret("subscription_key"), "dummy-password-two")

  # Remove from memory
  clear_secrets()
  expect_error(
    get_secret("subscription_key"),
    glue::glue("No {DEFAULT_SECRETS_NAME} file.")
  )
})
