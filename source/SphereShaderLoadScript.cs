using Godot;
using System;

public partial class SphereShaderLoadScript : MeshInstance3D
{
	[Export]
	public Godot.SubViewport viewport;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print(viewport.Name);
		//viewport = GetNode<Godot.SubViewport>("Shaders/SphereViewPort");
		//SetInstanceShaderParameter("sphere_noise", viewport.GetTexture());
		Material m = GetActiveMaterial(0);
		m.Set("sphere_noise", viewport.GetTexture());
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
