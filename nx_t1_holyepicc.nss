//::///////////////////////////////////////////////
//:: Epic Holy Trap
//:: NW_T1_HolyEpicC
//:: Copyright (c) 2007 Obsidian Ent.
//:://////////////////////////////////////////////
/*
    Strikes the entering undead with a beam of pure
    sunlight for 20d10 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Ryan Young
//:: Created On: 1.22.2007
//:://////////////////////////////////////////////
//::Modyfication by Moreus 2009

//TrapStart
void UseTrap(object oTarget);

void main()
{
object oTC= GetTrapCreator(OBJECT_SELF);
object oPC= GetEnteringObject();
if(GetIsObjectValid(oTC)&& !GetIsFriend(oPC,oTC))
AssignCommand(oTC,UseTrap(oPC));
else
UseTrap(oPC);
}

void UseTrap(object oTarget)
{
    //Declare major variables
    effect eDam = EffectDamage(d10(20), DAMAGE_TYPE_DIVINE);
    effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        //Apply Holy Damage and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
    else
    {
        eDam = EffectDamage(d4(16), DAMAGE_TYPE_DIVINE);
        //Apply Holy Damage and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}