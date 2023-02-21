/*
Scanning Best Practices:

bool loading
just a boolean, set "Memory Scan Options" to HogwartsLegacy.exe - 1 on loading screen, 0 everywhere else

string quest
UTF String
From a fresh game, get past the health tutorial and walk out to the cliff for a bit.

In the Menus                   // 7209033
On Quest: The Path to Hogwarts // 7209039
On Quest: Welcome to Hogwarts  // 7209039
*/

state("AtomicHeart-Win64-Shipping", "Steam v1.0")
{
    bool InGame    : 0x646CC40;
}

state("AtomicHeart-WinGDK-Shipping", "XboxGP v1.0")
{
    bool InGame    : 0x6544F60;
}

init
{
switch (modules.First().ModuleMemorySize) 
    {
        case 451141632: 
            version = "Steam v1.0";
            break;
        case 421130240: 
            version = "XboxGP v1.0";
            break;
        default:
        print("Unknown version detected");
        return false;
    }
}

startup
  {
	// Asks user to change to game time if LiveSplit is currently set to Real Time.
		if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {        
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Atomic Heart",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

onStart
{
    // This makes sure the timer always starts at 0.00
    timer.IsGameTimePaused = true;
}

update
{
	//DEBUG CODE 
	//print(modules.First().ModuleMemorySize.ToString());
	//print(current.loading.ToString());
}

isLoading
{
    return !current.InGame;
}

exit
{
    //pauses timer if the game crashes
	timer.IsGameTimePaused = true;
}