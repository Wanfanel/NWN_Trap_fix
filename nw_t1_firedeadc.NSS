//::///////////////////////////////////////////////
//:: Deadly Fire Trap
//:: NW_T1_FireDeadC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 14d6 damage to all within 10 ft.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 4th, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 27, 2001
//::Modyfication by Moreus 2009
#include "NW_I0_SPELLS"
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
    int bValid;
    location lTarget = GetLocation(oTarget);
    int nDamage;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam;
    int nSaveDC = 26;

    //Get first object in the target area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
    //Cycle through the target area until all object have been targeted
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Roll damage
            nDamage = d6(25);
            //Adjust the trap damage based on the feats of the target
            if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC, SAVING_THROW_TYPE_TRAP))
            {
                if (GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                {
                    nDamage /= 2;
                }
            }
            else if (GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
            {
                nDamage = 0;
            }
            else
            {
                nDamage /= 2;
            }
            if (nDamage > 0)
            {
                //Set damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                if (nDamage > 0)
                {
                    //Apply effects to the target.
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                }
            }
        }
        //Get next target in shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
    }
}