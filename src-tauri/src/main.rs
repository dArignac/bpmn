// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use std::env;
use tauri::Manager;

// the payload type must implement `Serialize` and `Clone`.
#[derive(Clone, serde::Serialize)]
struct LoadedPayload {
  initial_file: String,
}

#[tauri::command]
async fn fetch_initial_source_file() -> String {
  let args: Vec<String> = env::args().collect();
  let mut initial_file: String = String::from("none");

  // the second element is the file path of a file that was opened with the application
  if args.len() == 2 {
    initial_file = args.get(1).unwrap().to_string()
  }

  initial_file.into()
}

fn main() {
    tauri::Builder::default()
        .setup(|app| {
            #[cfg(debug_assertions)]
            {
                let window = app.get_window("main").unwrap();
                window.open_devtools();
            }
            Ok(())
        })
        .invoke_handler(tauri::generate_handler![fetch_initial_source_file])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
