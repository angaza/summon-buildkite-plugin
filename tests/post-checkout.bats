#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

# Uncomment to enable stub debugging
# export GIT_STUB_DEBUG=/dev/tty

setup() {
  HOOKS_PATH="$PWD/hooks"

  pushd "$(mktemp -d)"
}

teardown() {
  popd
}

@test "calls summon given no args" {
  stub summon "cat @SUMMONENVFILE : touch summoned_no_args"

  run "$HOOKS_PATH/post-checkout"

  assert [ -e summoned_no_args ]
  assert_line --regexp '^source <\(summon .*' # command was echoed?
  assert_success
  unstub summon
}

@test "calls summon given all args" {
  export BUILDKITE_PLUGIN_SUMMON_PROVIDER=provider-name
  export BUILDKITE_PLUGIN_SUMMON_SECRETS_FILE=file-path
  export BUILDKITE_PLUGIN_SUMMON_ENVIRONMENT=env-name

  stub summon "-p provider-name -f file-path -e env-name cat @SUMMONENVFILE : touch summoned_all_args"

  rm -f summoned_all_args

  run "$HOOKS_PATH/post-checkout"

  assert [ -e summoned_all_args ]
  assert_line --regexp '^source <\(summon .*'
  assert_success
  unstub summon
}

@test "exports variables from summon output" {
  stub summon "cat @SUMMONENVFILE : echo EXPORTED_FROM_SUMMON=some-value"

  run bash -c "source $HOOKS_PATH/post-checkout; echo \$EXPORTED_FROM_SUMMON"

  assert_line --partial "some-value"
  assert_success
  unstub summon
}

@test "re-runs with output if summon fails" {
  stub summon \
      "cat @SUMMONENVFILE : false" \
      "echo : echo error message"

  run "$HOOKS_PATH/post-checkout"

  assert_line --partial "error message"
  assert_failure
  unstub summon
}
