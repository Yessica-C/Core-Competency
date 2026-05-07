using System;
using System.Collections.Generic;
using Godot;

[GlobalClass, Icon("res://resources/Icons/PropNode.png")]
public partial class Prop : RigidBody3D
{
    [Export]
    public int RenderLayer = 1;
    private Vector3 TargetPos;
    private bool Held = false;
    private Node OldParent;

    public override void _EnterTree()
    {
        base._EnterTree();
        setVisibleLayer(RenderLayer);
    }

    public void PickUp(Node3D NewHolder)
    {
        Held = true;
        Freeze = true;
        OldParent = GetParent();
        DisableHitboxes();
        Reparent(NewHolder);
        //SlideTo(NewHolder.GlobalPosition);
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

    public void setVisibleLayer(int newLayer)
    {
        Godot.Collections.Array<Node> allMeshes = FindChildren("*", "MeshInstance3D", true);
        foreach(Node n in allMeshes)
        {
            if (n is MeshInstance3D)
            {
                MeshInstance3D mesh = (MeshInstance3D)n;
                for(int i = 1; i < 20; i++)
                {
                    if(i == newLayer)//if is new layer turn on
                    {
                        mesh.SetLayerMaskValue(i, true);
                    }
                    else//if is not new layer turn off
                    {
                        mesh.SetLayerMaskValue(i, false);
                    }
                }
            }
        }
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