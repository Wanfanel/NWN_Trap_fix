//::///////////////////////////////////////////////
//:: Minor Sonic Trap
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the creature is stunned
//:: for 2 rounds.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 16, 2001
//:://////////////////////////////////////////////
//::Modyfication by Moreus 2009
#include "NW_I0_SPELLS"
//TrapStart
void UseTrap(location lTarget);

void main()
{
object oTC= GetTrapCreator(OBJECT_SELF);
location lTarget= GetLocation(GetEnteringObject());
if(GetIsObjectValid(oTC))
AssignCommand(oTC,UseTrap(lTarget));
else
UseTrap(lTarget);
}

void UseTrap(location lTarget)
{
    //Declare major variables
    object oTarget;
    effect eStun = EffectStunned();
    effect eFNF = EffectVisualEffect( VFX_HIT_SPELL_SONIC );
    effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
    effect eLink = EffectLinkEffects(eStun, eMind);
    effect eDam = EffectDamage(d4(2), DAMAGE_TYPE_SONIC);
    //Apply the FNF to the spell location
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eFNF,lTarget);
    //Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,lTarget);
    while (GetIsObjectValid(oTarget))
    {
        DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        //Make a Will roll to avoid being stunned
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, 12, SAVING_THROW_TYPE_TRAP))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2));
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
    }
}