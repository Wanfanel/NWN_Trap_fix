//::///////////////////////////////////////////////
//:: Strong Spike Trap
//:: NW_T1_SpikeStrC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a spike for
    5d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 4th , 2001
//:://////////////////////////////////////////////
#include "MOR_I0_TRAPS"
//::Modyfication by Moreus 2009

void main()
{
object oTC= GetTrapCreator(OBJECT_SELF);
object oPC= GetEnteringObject();
if(GetIsObjectValid(oTC))
AssignCommand(oTC,DoTrapSpike(d6(5),oPC));
else
DoTrapSpike(d6(5),oPC);
}
