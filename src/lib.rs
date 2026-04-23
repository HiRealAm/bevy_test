mod game;

use bevy::prelude::*;

// This is the entry point for the web app
#[cfg(target_arch = "wasm32")]
use wasm_bindgen::prelude::*;

#[cfg(target_arch = "wasm32")]
#[wasm_bindgen(start)]
pub fn main() {
    app_runner();
}

pub fn app_runner() {
    let mut app = App::new();

    app.add_plugins(DefaultPlugins);

    app.add_plugins(game::ExampleGamePlugin);
    app.run();
}