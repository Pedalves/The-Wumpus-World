using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cell : MonoBehaviour
{
    public Vector2 Pos;

	public void AgentIn()
    {
        CellEffect[] cellEffects = GetComponentsInChildren<CellEffect>();
        if(cellEffects.Length > 0)
        {
            foreach(CellEffect fx in cellEffects)
            {
                fx.Action();
            }
        }
    }

    public void AgentInteract()
    {
        CellEffect[] cellEffects = GetComponentsInChildren<CellEffect>();
        if (cellEffects.Length > 0)
        {
            foreach (CellEffect fx in cellEffects)
            {
                fx.Interact();
            }
        }
    }

    public void AgentDamage(int damage)
    {
        CellEffect[] cellEffects = GetComponentsInChildren<CellEffect>();
        if (cellEffects.Length > 0)
        {
            foreach (CellEffect fx in cellEffects)
            {
                fx.Damage(damage);
            }
        }
    }

}
