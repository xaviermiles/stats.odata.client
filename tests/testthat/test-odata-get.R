test_that("Getting/setting subscription key works", {
  on.exit({
    if (exists("tmp") && file.exists(tmp))
      file.remove(tmp)
  })
  clear_secrets()

  # TODO: How to run below check if legitimate yml file does exist :^)
  # expect_error(get_secret("subscription_key"), "No golem-secrets.yml file.")

  # Add secrets file and check it reads in
  tmp <- tempfile("golem-secrets.yml", tmpdir = ".")
  writeLines(c("default:",
               "  subscription_key: dummy-password"),
             con = tmp)
  expect_equal(
    get_secret("subscription_key", file = tmp),
    "dummy-password"
  )

  # Add to memory and check this takes precedence over file
  set_secrets("subscription_key" = "dummy-password-two")
  expect_equal(get_secret("subscription_key"), "dummy-password-two")

  # Remove secrets file and should still read from memory
  file.remove(tmp)
  expect_equal(get_secret("subscription_key"), "dummy-password-two")

  # Remove from memory
  clear_secrets()
  expect_type()
})
