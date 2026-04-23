use bevy::prelude::*;

const PLAYER_SPEED: f32 = 280.0;
const BOUNDS_X: f32 = 460.0;
const BOUNDS_Y: f32 = 260.0;

pub struct ExampleGamePlugin;

impl Plugin for ExampleGamePlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(Startup, setup)
            .add_systems(Update, (move_player, confine_player));
    }
}

#[derive(Component)]
struct Player;

fn setup(mut commands: Commands) {
    commands.spawn(Camera2dBundle::default());

    commands.spawn(SpriteBundle {
        sprite: Sprite {
            color: Color::srgb(0.2, 0.8, 1.0),
            custom_size: Some(Vec2::new(42.0, 42.0)),
            ..default()
        },
        transform: Transform::from_xyz(0.0, 0.0, 0.0),
        ..default()
    });

    commands.spawn((
        Player,
        SpriteBundle {
            sprite: Sprite {
                color: Color::srgb(0.95, 0.4, 0.25),
                custom_size: Some(Vec2::new(50.0, 50.0)),
                ..default()
            },
            transform: Transform::from_xyz(0.0, 0.0, 1.0),
            ..default()
        },
    ));
}

fn move_player(
    keyboard: Res<ButtonInput<KeyCode>>,
    mut query: Query<&mut Transform, With<Player>>,
    time: Res<Time>,
) {
    let mut input = Vec2::ZERO;

    if keyboard.pressed(KeyCode::KeyA) || keyboard.pressed(KeyCode::ArrowLeft) {
        input.x -= 1.0;
    }
    if keyboard.pressed(KeyCode::KeyD) || keyboard.pressed(KeyCode::ArrowRight) {
        input.x += 1.0;
    }
    if keyboard.pressed(KeyCode::KeyW) || keyboard.pressed(KeyCode::ArrowUp) {
        input.y += 1.0;
    }
    if keyboard.pressed(KeyCode::KeyS) || keyboard.pressed(KeyCode::ArrowDown) {
        input.y -= 1.0;
    }

    if input == Vec2::ZERO {
        return;
    }

    let direction = input.normalize();
    let delta = direction * PLAYER_SPEED * time.delta_seconds();

    if let Ok(mut transform) = query.get_single_mut() {
        transform.translation.x += delta.x;
        transform.translation.y += delta.y;
    }
}

fn confine_player(mut query: Query<&mut Transform, With<Player>>) {
    if let Ok(mut transform) = query.get_single_mut() {
        transform.translation.x = transform.translation.x.clamp(-BOUNDS_X, BOUNDS_X);
        transform.translation.y = transform.translation.y.clamp(-BOUNDS_Y, BOUNDS_Y);
    }
}
