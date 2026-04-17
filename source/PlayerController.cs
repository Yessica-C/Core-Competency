using Godot;
using System;
using System.Runtime.CompilerServices;

public partial class PlayerController : CharacterBody3D
{
    [Export]
    public float Speed = 5.0f;
    
    [Export]
    public float JumpForce = 10.0f;
    
    [Export]
    public float Gravity = 30.0f;
    
    [Export]
    public float HorizontalMouseSensitivity = 0.005f;
    
    private float rotationX = 0.0f;
    private float rotationY = 0.0f;
    private bool isJumping = false;
    private bool HoldingProp = false;
    private Prop HeldProp = null;

    [Export]
    public RayCast3D CameraRay;
    [Export]
    public Marker3D HandPos;
    
    #region Engine Functions
    public override void _Ready()
    {
        // Hide cursor and lock it
        Input.MouseMode = Input.MouseModeEnum.Captured;
        if (CameraRay == null)
        {
            GD.Print("no cam ray");
        }
        else
        {
            GD.Print("cam ray");
        }
    }
    public override void _Input(InputEvent @event)
    {
        if (@event is InputEventMouseMotion mouseMotion)
        {
            HandleRotation(mouseMotion);
        }
        if(@event.IsActionPressed("interact"))
        {
            HandleInteract();
        }
    }

    public override void _PhysicsProcess(double delta)
    {
        Vector3 newVelocity = Velocity;
        newVelocity = HandleWASD(newVelocity);
        newVelocity = HandleJumpAndGravity(newVelocity, delta);

        Velocity = newVelocity;
        MoveAndSlide();
    }
    #endregion Engine Functions

    #region Motion Functions
    private void HandleRotation(InputEventMouseMotion mouseMotion)
    {
        rotationY -= mouseMotion.Relative.X * HorizontalMouseSensitivity;
        
        // Apply rotation to the player
        Rotation = new Vector3(0, rotationY, 0);
    }
    private Vector3 HandleWASD(Vector3 startingVelocity)
    {
        Vector3 newVelocity = startingVelocity;
        // Get input directions

        Vector3 inputDirection = Vector3.Zero;
        if (Input.IsActionPressed("forward"))
            inputDirection.Z -= 1;
        if (Input.IsActionPressed("backward"))
            inputDirection.Z += 1;
        if (Input.IsActionPressed("left"))
            inputDirection.X -= 1;
        if (Input.IsActionPressed("right"))
            inputDirection.X += 1;
        
        
        // Normalize input to prevent faster diagonal movement
        if (inputDirection.Length() > 0)
            inputDirection = inputDirection.Normalized();

        // Convert input to world space based on player rotation
        Vector3 worldDirection = inputDirection.Rotated(Vector3.Up, Rotation.Y);
        
        // Apply movement
        newVelocity.X = worldDirection.X * Speed;
        newVelocity.Z = worldDirection.Z * Speed;

        return newVelocity;
    }

    private Vector3 HandleJumpAndGravity(Vector3 startingVelocity, double delta)
    {
        Vector3 newVelocity = startingVelocity;
        
        // Handle gravity
        if (!IsOnFloor())
        {
            newVelocity.Y -= Gravity * (float)delta;
        }
        else if (isJumping)
        {
            newVelocity.Y = JumpForce;
            isJumping = false;
        }
        // Handle jumping
        if (Input.IsActionJustPressed("jump") && IsOnFloor())
        {
            isJumping = true;
        }
        return newVelocity;
    }
    #endregion Motion Functions

    #region Interaction
    private void HandleInteract()
    {
        if(HoldingProp)
        {
            HeldProp.Drop();
            HoldingProp = false;
            HeldProp = null;
        }
        else if (!HoldingProp)
        {
            if (CameraRay.IsColliding())
            {
                Object collider = CameraRay.GetCollider();
                if (collider is Prop)
                {
                    HoldingProp = true;
                    HeldProp = (Prop)CameraRay.GetCollider();
                    HeldProp.PickUp();
                    HeldProp.SlideTo(HandPos.GlobalPosition);
                    HeldProp.Reparent(HandPos);
                }
            }
        }
    }
    #endregion Interaction
}
