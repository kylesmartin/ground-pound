#ifndef PLAYER_H
#define PLAYER_H

#include <godot_cpp/classes/character_body2d.hpp>

namespace godot {
    class Player : public CharacterBody2D {
        GDCLASS(Player, CharacterBody2D)

        private:
            float speed;

        protected:
            static void _bind_methods();

        public:
            Player();
            ~Player();

            void move(Vector2 input_dir, float delta);
            void set_speed(const float p_speed);
            float get_speed() const;
    };
}

#endif
