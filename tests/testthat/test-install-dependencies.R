context("install tutorial dependencies")

test_that("tutorial dependency check works (interactive)", {
  skip_if_not(interactive())

  tutorial_deps <- tempfile("tutorial-deps", fileext = ".R")
  writeLines("library(pkg1)\npkg2::n()", con = tutorial_deps)
  on.exit(unlink(tutorial_deps), add = TRUE)

  expect_equal(
    with_mock(
      menu = function(title, choices) 1,
      install.packages = function(pkgs) "mock install",
      install_tutorial_dependencies(tutorial_deps)
    ),
    "mock install"
  )

  expect_silent(
    with_mock(
      menu = function(title, choices) 2,
      install_tutorial_dependencies(tutorial_deps)
    )
  )
})

test_that("tutorial dependency check works (not interactive)", {
  skip_if(interactive())

  tutorial_deps <- tempfile("tutorial-deps", fileext = ".R")
  writeLines("library(pkg1)\npkg2::n()", con = tutorial_deps)
  on.exit(unlink(tutorial_deps), add = TRUE)

  expect_error(
    with_mock(
      menu = function(title, choices) 2,
      install_tutorial_dependencies(tutorial_deps)
    )
  )
})

test_that("tutorial dependency check returns NULL for no dependencies", {
  tutorial_deps <- tempfile("tutorial-deps", fileext = ".R")
  writeLines("sum(1:3)", con = tutorial_deps)
  on.exit(unlink(tutorial_deps), add = TRUE)

  expect_silent(install_tutorial_dependencies(tutorial_deps))
})