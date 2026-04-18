using Godot;
using System;

public partial class ShaderSphere : MeshInstance3D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		//reset rotation every frame to free it of player camera rotation
		GlobalRotation = new Vector3(0, 0, 0);
	}
}
