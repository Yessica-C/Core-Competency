using Godot;

public partial class CameraVerticalGimble : Node3D
{
    [Export]
    public float MouseSensitivity = 0.005f;
    private float rotationX = 0;

    public override void _Input(InputEvent @event)
    {
        if (@event is InputEventMouseMotion mouseMotion)
        {
            HandleRotation(mouseMotion);
        }
    }
    private void HandleRotation(InputEventMouseMotion mouseMotion)
    {
        rotationX -= mouseMotion.Relative.Y * MouseSensitivity;
        
        // Limit vertical rotation to prevent flipping (radians)
        rotationX = Mathf.Clamp(rotationX, -1.5f, 1.5f);
        
        // Apply rotation to the player
        Rotation = new Vector3(rotationX, 0, 0);
    }
}