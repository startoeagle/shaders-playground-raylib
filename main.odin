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

	rl.SetTargetFPS(30)
	for !rl.WindowShouldClose() {
		shader := rl.LoadShader(nil, strings.clone_to_cstring(fragShaderFilename))

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

		rl.UnloadShader(shader)

		virtual.arena_free_all(&arena)
	}
}
