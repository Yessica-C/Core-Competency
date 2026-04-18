using System;
using System.Collections.Generic;
using Godot;

[GlobalClass, Icon("res://resources/Icons/PropNode.png")]
public partial class Prop : RigidBody3D
{
    private Vector3 TargetPos;
    private bool Held = false;
    private Node OldParent;
    public void PickUp(Node3D NewHolder)
    {
        Held = true;
        Freeze = true;
        OldParent = GetParent();
        DisableHitboxes();
        Reparent(NewHolder);
        SlideTo(NewHolder.GlobalPosition);
    }

    public void SlideTo(Vector3 Destination)
    {
        GlobalPosition = Destination;
    }

    public void Drop()
    {
        Held = false;
        Freeze = false;
        Sleeping = false;
        EnableHitboxes();
        Reparent(OldParent);
    }

    public bool IsHeld()
    {
        return Held;
    }

    private void DisableHitboxes()
    {        
        Godot.Collections.Array<Node> children = GetChildren();
        foreach(Node child in children)
        {
            if (child is CollisionShape3D)
            {
                child.SetDeferred("disabled", true);
            }
        }
    }

    private void EnableHitboxes()
    {
        Godot.Collections.Array<Node> children = GetChildren();
        foreach(Node child in children)
        {
            if (child is CollisionShape3D)
            {
                child.SetDeferred("disabled", false);
            }
        }
    }
}