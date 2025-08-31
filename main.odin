package main

import "core:strings"
import rl "vendor:raylib"

import "core:mem/virtual"


main :: proc() {
	arena: virtual.Arena
	res := virtual.arena_init_static(&arena)
	switch res {
	case .None:
		{}
	case .Out_Of_Memory, .Invalid_Pointer, .Invalid_Argument, .Mode_Not_Implemented:
		return
	}

	context.allocator = virtual.arena_allocator(&arena)

	rl.InitWindow(640, 480, "Hello shaders from raylib")

	target := rl.LoadRenderTexture(640, 480)

	fragShaderFilename := "shader.glsl"
	shader := rl.LoadShader(nil, strings.clone_to_cstring(fragShaderFilename))
	defer rl.UnloadShader(shader)
	center_uniform := rl.GetShaderLocation(shader, "center")
	julia_center_uniform := rl.GetShaderLocation(shader, "julia_center")
	zoom_uniform := rl.GetShaderLocation(shader, "zoom")

	center: [2]f32
	julia_center: [2]f32
	zoom: f32 = 1

	rl.SetShaderValue(shader, center_uniform, raw_data(center[:]), .VEC2)
	rl.SetShaderValue(shader, zoom_uniform, &zoom, .FLOAT)
	rl.SetShaderValue(shader, julia_center_uniform, raw_data(julia_center[:]), .VEC2)

	rl.SetTargetFPS(60)
	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		if rl.IsMouseButtonDown(.LEFT) {
			mouse_delta := rl.GetMouseDelta()
			speed :: 0.3
			center += mouse_delta * dt * speed * zoom
			rl.SetShaderValue(shader, center_uniform, raw_data(center[:]), .VEC2)
		}

		if rl.IsMouseButtonDown(.RIGHT) {
			mouse_delta := rl.GetMouseDelta()
			julia_speed :: 0.03
			julia_center += mouse_delta * dt * julia_speed
			rl.SetShaderValue(shader, julia_center_uniform, raw_data(julia_center[:]), .VEC2)
		}

		mouse_wheel := rl.GetMouseWheelMove()
		if mouse_wheel != 0 {
			zoom_scale :: 0.1
			zoom += mouse_wheel * zoom_scale * zoom
			rl.SetShaderValue(shader, zoom_uniform, &zoom, .FLOAT)
		}


		rl.BeginDrawing()
		rl.ClearBackground(rl.RAYWHITE)

		rl.BeginShaderMode(shader)
		rl.DrawTextureRec(
			target.texture,
			rl.Rectangle{x = 0, y = 0, width = 640, height = 480},
			{0, 0},
			rl.WHITE,
		)
		rl.EndShaderMode()

		rl.EndDrawing()


		virtual.arena_free_all(&arena)
	}
}
