using Godot;

public partial class AreaTrigger : Area3D
{
    PlayerController player;
    public override void _Ready()
    {
        player = GetNode<PlayerController>("/root/Game/PlayerController");
        if (player == null)
        {
            GD.Print("no player");
        }
        else
        {
            GD.Print("yes player");
        }
    }
    public override void _Process(double delta)
    {
        if(OverlapsBody(player))
        {
            //GD.Print("Player in zone");
        }
    }
}