// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use std::{env, ffi::OsString};
use tauri::Manager;

fn main() {
    tauri::Builder::default()
        .setup(|app| {
            // FIXME remove once testing is done
            let args: Vec<String> = env::args().collect();
            let args_os: Vec<OsString> = env::args_os().collect();
            println!("args: {:?}", args);
            println!("argsOs: {:?}", args_os);
            #[cfg(debug_assertions)]
            {
                let window = app.get_window("main").unwrap();
                window.open_devtools();
            }
            Ok(())
        })
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
