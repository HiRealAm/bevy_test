mod game;

use bevy::{app::ScheduleRunnerPlugin, prelude::*};

fn main() {
    let has_display =
        std::env::var_os("DISPLAY").is_some() || std::env::var_os("WAYLAND_DISPLAY").is_some();

    let mut app = App::new();

    if has_display {
        app.add_plugins(DefaultPlugins.set(WindowPlugin {
            primary_window: Some(Window {
                title: "Bevy Example Project".to_string(),
                resolution: (1024., 640.).into(),
                ..default()
            }),
            ..default()
        }))
        .add_plugins(game::ExampleGamePlugin);
    } else {
        app.add_plugins(MinimalPlugins.set(ScheduleRunnerPlugin::run_once()))
            .add_systems(Startup, setup_headless);
    }

    app.run();
}

fn setup_headless() {
    info!("No DISPLAY/WAYLAND_DISPLAY detected; ran Bevy in one-shot headless mode.");
}
