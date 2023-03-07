#include "player.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void Player::_bind_methods() {
    ClassDB::bind_method(D_METHOD("move", "input_dir", "delta"), &Player::move);
    ClassDB::bind_method(D_METHOD("get_speed"), &Player::get_speed);
    ClassDB::bind_method(D_METHOD("set_speed", "p_speed"), &Player::set_speed);
    ClassDB::add_property("Player", PropertyInfo(Variant::FLOAT, "speed"), "set_speed", "get_speed");
}

Player::Player() {
    // initialize any variables here
    speed = 10.0;
}

Player::~Player() {
    // add cleanup here
}

void Player::move(Vector2 input_dir, float delta) {
    set_velocity(input_dir * speed);
    move_and_slide();
}

void Player::set_speed(const float p_speed) {
    speed = p_speed;
}

float Player::get_speed() const {
    return speed;
}
