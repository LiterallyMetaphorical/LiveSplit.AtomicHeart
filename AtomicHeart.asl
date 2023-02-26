/*
Scanning Best Practices:

bool InGame
just a boolean, set "Memory Scan Options" to AtomicHeart-Win64-Shipping.exe - 0 on loading screen, 1 in game and on main menu

int InGame
set "Memory Scan Options" to AtomicHeart-Win64-Shipping.exe - scan for a 4Byte value of 2 while on the main menu, and 3 while in the loading screen. as well as in game
*/

state("AtomicHeart-Win64-Shipping", "Steam v1.0")
{
    bool InGame    : 0x646CC40;
    int  MainMenu  : 0x6349DC0; // doesnt actually work
}

state("AtomicHeart-WinGDK-Shipping", "XboxGP v1.0")
{
    bool InGame    : 0x6544F60;
    int  MainMenu  : 0x6349DC0; // doesnt actually work
}

state("AtomicHeart-Win64-Shipping", "VKPlay v1.0")
{
    bool InGame    : 0x646AB40;
    int  MainMenu  : 0x6345C40;
}

state("AtomicHeart-Win64-Shipping", "Steam v1.1")
{
    bool InGame    : 0x646ECC0;
    int  MainMenu  : 0x6349DC0;
}

state("AtomicHeart-WinGDK-Shipping", "XboxGP v1.1")
{
    bool InGame    : 0x6551620;
    int  MainMenu  : 0x6349DC0; // doesnt actually work
}

state("AtomicHeart-Win64-Shipping", "Steam v1.2")
{
    bool InGame    : 0x646ECC0;
    int  MainMenu  : 0x6349DC0;
}

init
{
switch (modules.First().ModuleMemorySize) //all case #'s converted from Decimal to Hexadecimal cause it looks pretty
    {
        case 0x1AE3E000: 
            version = "Steam v1.0";
            break;
        case 0x1919F000: 
            version = "XboxGP v1.0";
            break;
        case 0x1BA55000: 
            version = "VKPlay v1.0";
            break;
        case 0x1AB7C000: 
            version = "Steam v1.1";
            break;
        case 0x18D77000: 
            version = "XboxGP v1.1";
            break;
        case 0x1ABB4000: 
            version = "Steam v1.2";
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

start
{
    return old.MainMenu == 2 && current.MainMenu == 3 && !current.InGame;
}

update
{
	//DEBUG CODE 
	//print(modules.First().ModuleMemorySize.ToString());
	//print(current.MainMenu.ToString());
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
