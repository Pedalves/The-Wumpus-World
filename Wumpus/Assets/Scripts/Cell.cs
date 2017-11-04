using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cell : MonoBehaviour
{
    public Vector2 Pos;

	public void AgentIn()
    {
        CellEffect cellEffect = GetComponent<CellEffect>();
        if (transform.childCount > 0)
        {
            GetComponentInChildren<CellEffect>().Action();
        }
        else if(cellEffect != null)
        {
            cellEffect.Action();
        }
    }

}
