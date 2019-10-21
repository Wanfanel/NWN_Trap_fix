// * Function for doing electrical traps
void TrapDoElectricalDamage(int ngDamageMaster, int nSaveDC, int nSecondary,    object oTarget);

// * apply effects of spike trap on entering object
void DoTrapSpike(int nDamage,object oTarget);

int MySavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0);

int MySavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{
    // -------------------------------------------------------------------------
    // GZ: sanity checks to prevent wrapping around
    // -------------------------------------------------------------------------
    if (nDC<1)
    {
       nDC = 1;
    }
    else if (nDC > 255)
    {
      nDC = 255;
    }

    effect eVis;
    int bValid = FALSE;
    int nSpellID;
    if(nSavingThrow == SAVING_THROW_FORT)
    {
        bValid = FortitudeSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            //eVis = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);	// no longer using NWN1 VFX; there is no analogous NWN2 VFX
        }
    }
    else if(nSavingThrow == SAVING_THROW_REFLEX)
    {
        bValid = ReflexSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            //eVis = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);	// no longer using NWN1 VFX; there is no analogous NWN2 VFX
        }
    }
    else if(nSavingThrow == SAVING_THROW_WILL)
    {
        bValid = WillSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            //eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);	// no longer using NWN1 VFX; there is no analogous NWN2 VFX
        }
    }

    nSpellID = GetSpellId();

    /*
        return 0 = FAILED SAVE
        return 1 = SAVE SUCCESSFUL
        return 2 = IMMUNE TO WHAT WAS BEING SAVED AGAINST
    */
    if(bValid == 0)
    {
        if((nSaveType == SAVING_THROW_TYPE_DEATH
         || nSpellID == SPELL_WEIRD
         || nSpellID == SPELL_FINGER_OF_DEATH) &&
         nSpellID != SPELL_HORRID_WILTING)
        {
            eVis = EffectVisualEffect(VFX_IMP_DEATH);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
    }
    //redundant comparison on bValid, let's move the eVis line down below
/*    if(bValid == 2)
    {
        eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
    }*/
    if(bValid == 1 || bValid == 2)
    {
        if(bValid == 2)
        {
            //eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);	// no longer using NWN1 VFX
			eVis = EffectVisualEffect( VFX_DUR_SPELL_SPELL_RESISTANCE );	// makes use of NWN2 VFX
            /*
            If the spell is save immune then the link must be applied in order to get the true immunity
            to be resisted.  That is the reason for returing false and not true.  True blocks the
            application of effects.
            */
            bValid = FALSE;
        }
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    }
    return bValid;
}
///////////////////
////////Electrical Trap//////////
///////////////////
void TrapDoElectricalDamage(int ngDamageMaster, int nSaveDC, int nSecondary,object oTarget)
{
    //Declare major variables
    object o2ndTarget;
    effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oTarget, BODY_NODE_CHEST);	// no longer using NWN1 VFX; does this still work?
    //effect eLightning = EffectVisualEffect( VFX_BEAM_LIGHTNING );	// makes use of NWN2 VFX
    int nDamageMaster = ngDamageMaster;
    int nDamage = nDamageMaster;
    effect eDam;
    effect eVis = EffectVisualEffect( VFX_IMP_LIGHTNING_S );
    location lTarget = GetLocation(oTarget);
    int nCount = 0;
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
        eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
        DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }

    object oCreator = GetTrapCreator(OBJECT_SELF);
    if (oCreator == OBJECT_INVALID)
    {
        oCreator = OBJECT_SELF; //pre-placed traps have no creator
    }

    //Reset the damage;
    nDamage = nDamageMaster;
    o2ndTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    while (GetIsObjectValid(o2ndTarget) && nCount <= nSecondary)
    {
        if(!GetIsReactionTypeFriendly(o2ndTarget, oCreator))
        {
            //check to see that the original target is not hit again.
            if(o2ndTarget != oTarget)
            {
                //Adjust the trap damage based on the feats of the target
                if(!MySavingThrow(SAVING_THROW_REFLEX, o2ndTarget, nSaveDC, SAVING_THROW_TYPE_ELECTRICITY))
                {
                    if (GetHasFeat(FEAT_IMPROVED_EVASION, o2ndTarget))
                    {
                        nDamage /= 2;
                    }
                }
                else if (GetHasFeat(FEAT_EVASION, o2ndTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, o2ndTarget))
                {
                    nDamage = 0;
                }
                else
                {
                    nDamage /= 2;
                }
                if (nDamage > 0)
                {
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                    //Apply the VFX impact and damage effect
                    DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, o2ndTarget));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, o2ndTarget);
                    //Connect the lightning stream from one target to another.
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, o2ndTarget, 0.75);
                    //Set the last target as the new start for the lightning stream
                    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, o2ndTarget, BODY_NODE_CHEST);	// no longer using NWN1 VFX; does this still work?
                    //eLightning = EffectVisualEffect( VFX_BEAM_LIGHTNING );	// makes use of NWN2 VFX
                }
            }
            //Reset the damage
            nDamage = nDamageMaster;
            //Increment the count
            nCount++;
        }
        //Get next target in the shape.
        o2ndTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    }
}


//::///////////////////////////////////////////////
//:: DoTrapSpike
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a spike trap. Reflex save allowed.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
// apply effects of spike trap on entering object
void DoTrapSpike(int nDamage,object oTarget)
{
    //Declare major variables


    int nRealDamage = GetReflexAdjustedDamage(nDamage, oTarget, 15, SAVING_THROW_TYPE_TRAP, OBJECT_SELF);
    if (nDamage > 0)
    {
        effect eDam = EffectDamage(nRealDamage, DAMAGE_TYPE_PIERCING);
        effect eVis = EffectVisualEffect(253);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }
}