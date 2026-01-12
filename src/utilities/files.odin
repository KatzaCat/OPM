package utilities

import "core:fmt"
import "core:os"
import "core:strings"

read_file_to_string :: proc(file_name: string) -> []byte {
  file_data, file_error := os.read_entire_file_from_filename_or_err(file_name);
  if file_error != os.ERROR_NONE {
    fmt.eprintfln("Failed to open file \"%s\" with error:\n\t%s", file_name, os.error_string(file_error));
    file_data = nil;
    os.exit(-1);
  }
  return file_data;
}

get_directory_to :: proc(file: string) -> string {
  folder_path: string = "";

  home_directory: string = "";
  if ODIN_OS == .Windows {
    home_directory = os.get_env_alloc("USERPROFILE");
  } else {
    home_directory = os.get_env_alloc("HOME");
  }
  if home_directory == "" {
    fmt.eprintln("Failed to find the o.s. HOME/USERPROFILE directory");
    os.exit(-1);
  }

  folder_path, _ = strings.concatenate({home_directory, "\\", file});

  return folder_path;
}