
context("validation-5.2-fields")


source("validate_helper.R")


test_that("5.2.1 - Field Selections On Objects, Interfaces, and Union Types", {

  "
  {
    dog {
      ...interfaceFieldSelection
    }
  }
  fragment interfaceFieldSelection on Pet {
    name
  }
  " %>%
  expect_r6()

  "
  {
    dog {
      ... on Dog {
        name
      }
      ...interfaceFieldSelection
    }
  }
  fragment interfaceFieldSelection on Pet {
    name
  }
  " %>%
  expect_r6()


  "
  {
    dog {
      ...fieldNotDefined
    }
  }
  fragment fieldNotDefined on Dog {
    meowVolume
  }
  " %>%
  expect_err("not all requested names are found")


  "
  {
    dog {
      ...definedOnImplementorsButNotInterface
    }
  }
  fragment definedOnImplementorsButNotInterface on Pet {
    nickname
  }
  " %>%
  expect_err("not all requested names are found")


  "
  {
    dog {
      ...inDirectFieldSelectionOnUnion
    }
  }
  fragment inDirectFieldSelectionOnUnion on CatOrDog {
    # TODO remove comment # __typename
    ... on Pet {
      name
    }
    ... on Dog {
      barkVolume
    }
  }
  " %>%
  expect_r6()


  "
  {
    dog {
      ...directFieldSelectionOnUnion
    }
  }
  fragment directFieldSelectionOnUnion on CatOrDog {
    name
    barkVolume
  }
  " %>%
  expect_err("fields may not be queried directly on a union object")

})




test_that("5.2.3 - Leaf Field Selections", {


  "
  {
    dog {
      ...scalarSelection
    }
  }
  fragment scalarSelection on Dog {
    barkVolume
  }
  " %>%
  expect_r6()

  "
  {
    dog {
      ...scalarSelectionsNotAllowedOnBoolean
    }
  }
  fragment scalarSelectionsNotAllowedOnBoolean on Dog {
    barkVolume {
      sinceWhen
    }
  }
  " %>%
  expect_err("Not allowed to query deeper into leaf")


  "
  query directQueryOnObjectWithoutSubFields {
    human
  }
  " %>%
  expect_err("non leaf selection does not have any children")

  "
  query directQueryOnInterfaceWithoutSubFields {
    pet
  }
  " %>%
  expect_err("non leaf selection does not have any children")

  "
  query directQueryOnUnionWithoutSubFields {
    catOrDog
  }
  " %>%
  expect_err("non leaf selection does not have any children")

})