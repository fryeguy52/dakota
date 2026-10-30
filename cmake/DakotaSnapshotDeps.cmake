# Dakota helpers for forcing snapshot dependency usage in selected builds

macro(dakota_use_json_snapshot snapshot_include_dir)
  if(NOT EXISTS "${snapshot_include_dir}/nlohmann/json.hpp")
    message(FATAL_ERROR
      "DAKOTA_FORCE_JSON_SNAPSHOT=ON but Dakota snapshot nlohmann/json headers "
      "were not found in ${snapshot_include_dir}.")
  endif()

  if(NOT TARGET nlohmann_json)
    add_library(nlohmann_json INTERFACE)
    add_library(nlohmann_json::nlohmann_json ALIAS nlohmann_json)
    target_include_directories(nlohmann_json INTERFACE "${snapshot_include_dir}")
  endif()
endmacro()

macro(dakota_use_gtest_snapshot snapshot_source_dir snapshot_binary_dir)
  if(NOT EXISTS "${snapshot_source_dir}/CMakeLists.txt")
    message(FATAL_ERROR
      "DAKOTA_FORCE_GTEST_SNAPSHOT=ON but Dakota snapshot GoogleTest sources "
      "were not found in ${snapshot_source_dir}.")
  endif()

  if(NOT TARGET GTest::gtest_main)
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    set(_dakota_saved_build_shared_libs ${BUILD_SHARED_LIBS})
    set(BUILD_SHARED_LIBS OFF)
    add_subdirectory("${snapshot_source_dir}" "${snapshot_binary_dir}")
    set(BUILD_SHARED_LIBS ${_dakota_saved_build_shared_libs})
  endif()
endmacro()
