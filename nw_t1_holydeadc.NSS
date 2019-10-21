//::///////////////////////////////////////////////
//:: Deadly Holy Trap
//:: NW_T1_HolyDeadC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering undead with a dose of holy
    water for 12d10 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 4th, 2001
//:://////////////////////////////////////////////
//::Modyfication by Moreus 2009

//TrapStart
void UseTrap(object oTarget);

void main()
{
object oTC= GetTrapCreator(OBJECT_SELF);
object oPC= GetEnteringObject();
if(GetIsObjectValid(oTC))
AssignCommand(oTC,UseTrap(oPC));
else
UseTrap(oPC);
}

void UseTrap(object oTarget)
{
    //Declare major variables
    int nAC = GetAC(oTarget);
    //Make attack roll
    int nRoll = d20() + 10 + 8;
    effect eDam = EffectDamage(d10(12), DAMAGE_TYPE_DIVINE);
    effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    if (nRoll > 0)
    {
        if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            //Apply Holy Damage and VFX impact
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        else
        {
            eDam = EffectDamage(d4(8), DAMAGE_TYPE_DIVINE);
            //Apply Holy Damage and VFX impact
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}