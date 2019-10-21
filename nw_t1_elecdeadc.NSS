//::///////////////////////////////////////////////
//:: Electrical Trap
//:: NW_T1_ElecDeadC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The creature setting off the trap is struck by
    a strong electrical current that arcs to 6 other
    targets doing 30d6 damage.  Can make a Reflex
    save for half damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 30, 2001
//:://////////////////////////////////////////////
//::Modyfication by Moreus 2009
#include "MOR_I0_TRAPS"

void main()
{
object oTC= GetTrapCreator(OBJECT_SELF);
object oPC= GetEnteringObject();
if(GetIsObjectValid(oTC))
AssignCommand(oTC,TrapDoElectricalDamage(d6(30),28,6,oPC));
else
TrapDoElectricalDamage(d6(30),28,6,oPC);
}
