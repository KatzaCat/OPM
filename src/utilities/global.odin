package utilities

@(private)
OPM_Global_ :: struct {
  current_build_name: string,
  current_project_type_path: string,

  path_to_project_types_file: string
};

global_data: OPM_Global_ = {};