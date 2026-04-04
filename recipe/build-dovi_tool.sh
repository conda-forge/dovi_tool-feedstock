#!/usr/bin/env bash
set -exuo pipefail

cd "${SRC_DIR}/dovi_tool_src"

if [[ -z "${CARGO_BUILD_TARGET:-}" && -n "${RUST_TARGET:-}" ]]; then
    export CARGO_BUILD_TARGET="${RUST_TARGET}"
fi

# On Linux, if we're cross-compiling, we need to tell fontconfig to dlopen its shared libraries instead of linking against them at build time.
if [[ "${target_platform:-}" == linux-* && "${build_platform:-}" != "${target_platform:-}" ]]; then
    export RUST_FONTCONFIG_DLOPEN=1
fi

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=thin

cargo-bundle-licenses \
    --format yaml \
    --output "${SRC_DIR}/THIRDPARTY_dovi_tool.yml"

cargo auditable install \
    --locked \
    --no-track \
    --bins \
    --root "${PREFIX}" \
    --path .
