using Godot;

public partial class TriggerHandler : Node
{
    public void ReceivePlayerTrigger(Node3D body)
    {
        if (body.IsClass("CharacterBody3D"))
        {
            GD.Print("I see you Henry");
        }
    }
}